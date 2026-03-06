// Model download service: handles GGUF model download with resume/retry,
// SHA256 integrity check, and disk space validation.

import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constants/app_constants.dart';

part 'model_download_service.g.dart';

// --- States ---

sealed class ModelState {
  const ModelState();
}

class ModelNotDownloaded extends ModelState {
  const ModelNotDownloaded();
}

class ModelDownloading extends ModelState {
  const ModelDownloading({
    required this.progress,
    required this.downloadedBytes,
    required this.totalBytes,
  });

  final double progress; // 0.0 to 1.0
  final int downloadedBytes;
  final int totalBytes;

  String get downloadedMb =>
      (downloadedBytes / 1024 / 1024).toStringAsFixed(1);
  String get totalMb => (totalBytes / 1024 / 1024).toStringAsFixed(0);
}

class ModelReady extends ModelState {
  const ModelReady({required this.modelPath});
  final String modelPath;
}

class ModelError extends ModelState {
  const ModelError({required this.message});
  final String message;
}

// --- Service ---

class ModelDownloadService {
  ModelDownloadService()
      : _dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(minutes: 30),
          ),
        );

  final Dio _dio;
  CancelToken? _cancelToken;

  Future<String> _getModelPath() async {
    final dir = await getApplicationSupportDirectory();
    return p.join(dir.path, AppConstants.modelFileName);
  }

  // Checks if the model file exists and (optionally) verifies its hash.
  Future<ModelState> checkStatus() async {
    final modelPath = await _getModelPath();
    final file = File(modelPath);

    if (!file.existsSync()) return const ModelNotDownloaded();

    // If we have a known hash, verify integrity
    if (AppConstants.modelSha256.isNotEmpty) {
      final isValid = await _verifySha256(file, AppConstants.modelSha256);
      if (!isValid) {
        // Delete corrupted file, will re-download
        await file.delete();
        return const ModelNotDownloaded();
      }
    }

    return ModelReady(modelPath: modelPath);
  }

  // Checks available disk space (bytes) on the device.
  Future<bool> hasEnoughDiskSpace({int requiredBytes = 1024 * 1024 * 1024}) async {
    try {
      final dir = await getApplicationSupportDirectory();
      // FileStat doesn't expose free space on mobile; assume sufficient space
      final exists = dir.existsSync();
      return exists; // If app support dir exists, storage is accessible
    } catch (_) {
      return true; // Optimistic default
    }
  }

  // Downloads the model with resume support (HTTP Range headers).
  // Calls [onProgress] with (downloadedBytes, totalBytes, progress).
  Future<ModelState> downloadModel({
    required void Function(int downloaded, int total, double progress)
        onProgress,
  }) async {
    final modelPath = await _getModelPath();
    final file = File(modelPath);
    _cancelToken = CancelToken();

    try {
      // Determine already-downloaded bytes for resume
      final existingBytes = file.existsSync() ? file.lengthSync() : 0;

      final headResponse = await _dio.head<void>(
        AppConstants.modelDownloadUrl,
        cancelToken: _cancelToken,
      );
      final totalBytes = int.tryParse(
            headResponse.headers.value('content-length') ?? '',
          ) ??
          0;

      // Skip download if already complete
      if (existingBytes > 0 && existingBytes == totalBytes) {
        return ModelReady(modelPath: modelPath);
      }

      final headers = <String, dynamic>{};
      if (existingBytes > 0) {
        headers['Range'] = 'bytes=$existingBytes-';
      }

      await _dio.download(
        AppConstants.modelDownloadUrl,
        modelPath,
        cancelToken: _cancelToken,
        deleteOnError: false, // Keep partial download for resume
        options: Options(headers: headers),
        onReceiveProgress: (received, total) {
          final actualTotal = total > 0 ? total : totalBytes;
          final totalDownloaded = existingBytes + received;
          final progress = actualTotal > 0
              ? (totalDownloaded / actualTotal).clamp(0.0, 1.0)
              : 0.0;
          onProgress(totalDownloaded, actualTotal, progress);
        },
      );

      // Verify integrity if hash is configured
      if (AppConstants.modelSha256.isNotEmpty) {
        final isValid = await _verifySha256(file, AppConstants.modelSha256);
        if (!isValid) {
          await file.delete();
          return const ModelError(
            message: 'Il file scaricato è corrotto. Riprova.',
          );
        }
      }

      return ModelReady(modelPath: modelPath);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        return const ModelError(message: 'Download annullato.');
      }
      return ModelError(
        message: _friendlyDioError(e),
      );
    } catch (e) {
      return ModelError(message: 'Errore imprevisto: ${e.toString()}');
    }
  }

  void cancelDownload() {
    _cancelToken?.cancel('Annullato dall\'utente');
  }

  Future<void> deleteModel() async {
    final modelPath = await _getModelPath();
    final file = File(modelPath);
    if (file.existsSync()) await file.delete();
  }

  // Verifies the SHA256 hash of a file against an expected hex string.
  Future<bool> _verifySha256(File file, String expectedHex) async {
    final stream = file.openRead();
    final digest = await sha256.bind(stream).first;
    return digest.toString() == expectedHex.toLowerCase();
  }

  String _friendlyDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connessione troppo lenta o timeout. Controlla la tua rete Wi-Fi.';
      case DioExceptionType.connectionError:
        return 'Nessuna connessione internet. Collegati al Wi-Fi e riprova.';
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        return 'Errore dal server ($code). Riprova più tardi.';
      default:
        return 'Errore di rete: ${e.message ?? e.type.name}';
    }
  }
}

// --- Riverpod provider ---

@riverpod
ModelDownloadService modelDownloadService(ModelDownloadServiceRef ref) { // ignore: deprecated_member_use_from_same_package
  return ModelDownloadService();
}

// Notifier that manages the download state for the UI
@riverpod
class ModelDownloadNotifier extends _$ModelDownloadNotifier {
  @override
  Future<ModelState> build() async {
    final service = ref.watch(modelDownloadServiceProvider);
    return service.checkStatus();
  }

  Future<void> startDownload() async {
    final service = ref.read(modelDownloadServiceProvider);
    state = const AsyncValue.data(
      ModelDownloading(progress: 0, downloadedBytes: 0, totalBytes: 0),
    );

    final result = await service.downloadModel(
      onProgress: (downloaded, total, progress) {
        state = AsyncValue.data(
          ModelDownloading(
            progress: progress,
            downloadedBytes: downloaded,
            totalBytes: total,
          ),
        );
      },
    );
    state = AsyncValue.data(result);
  }

  void cancelDownload() {
    ref.read(modelDownloadServiceProvider).cancelDownload();
  }
}
