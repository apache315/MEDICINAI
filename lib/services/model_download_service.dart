// Model download service: handles GGUF model + mmproj download with resume/retry,
// SHA256 integrity check, and disk space validation.
//
// Both the LLM model (~500 MB) and the vision projector mmproj (~205 MB) must be
// present before ModelReady is returned. Total download ~705 MB.

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

  final double progress; // 0.0 to 1.0 across both files combined
  final int downloadedBytes;
  final int totalBytes;

  String get downloadedMb =>
      (downloadedBytes / 1024 / 1024).toStringAsFixed(1);
  String get totalMb => (totalBytes / 1024 / 1024).toStringAsFixed(0);
}

class ModelReady extends ModelState {
  const ModelReady({required this.modelPath, required this.mmprojPath});
  final String modelPath;
  final String mmprojPath; // vision projector for multimodal inference
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

  Future<String> _getMmprojPath() async {
    final dir = await getApplicationSupportDirectory();
    return p.join(dir.path, AppConstants.mmprojFileName);
  }

  // Returns ModelReady only if BOTH model and mmproj files are present and valid.
  Future<ModelState> checkStatus() async {
    final modelPath = await _getModelPath();
    final mmprojPath = await _getMmprojPath();
    final modelFile = File(modelPath);
    final mmprojFile = File(mmprojPath);

    if (!modelFile.existsSync() || !mmprojFile.existsSync()) {
      return const ModelNotDownloaded();
    }

    if (AppConstants.modelSha256.isNotEmpty) {
      if (!await _verifySha256(modelFile, AppConstants.modelSha256)) {
        await modelFile.delete();
        return const ModelNotDownloaded();
      }
    }

    if (AppConstants.mmprojSha256.isNotEmpty) {
      if (!await _verifySha256(mmprojFile, AppConstants.mmprojSha256)) {
        await mmprojFile.delete();
        return const ModelNotDownloaded();
      }
    }

    return ModelReady(modelPath: modelPath, mmprojPath: mmprojPath);
  }

  Future<bool> hasEnoughDiskSpace({int requiredBytes = 1024 * 1024 * 1024}) async {
    try {
      final dir = await getApplicationSupportDirectory();
      return dir.existsSync();
    } catch (_) {
      return true;
    }
  }

  // Downloads both model and mmproj with resume support (HTTP Range headers).
  // Progress is reported as a combined value across both files.
  // Calls [onProgress] with (downloadedBytes, totalBytes, progress).
  Future<ModelState> downloadModel({
    required void Function(int downloaded, int total, double progress)
        onProgress,
  }) async {
    _cancelToken = CancelToken();

    try {
      final modelPath = await _getModelPath();
      final mmprojPath = await _getMmprojPath();

      // Fetch content-lengths for both files upfront so we can report combined progress.
      final modelHead = await _dio.head<void>(
        AppConstants.modelDownloadUrl,
        cancelToken: _cancelToken,
      );
      final mmprojHead = await _dio.head<void>(
        AppConstants.mmprojDownloadUrl,
        cancelToken: _cancelToken,
      );
      final modelTotal =
          int.tryParse(modelHead.headers.value('content-length') ?? '') ?? 0;
      final mmprojTotal =
          int.tryParse(mmprojHead.headers.value('content-length') ?? '') ?? 0;
      final grandTotal = modelTotal + mmprojTotal;

      // Download model (phase 1 of 2)
      final modelResult = await _downloadFile(
        url: AppConstants.modelDownloadUrl,
        destPath: modelPath,
        expectedTotal: modelTotal,
        priorBytes: 0,
        grandTotal: grandTotal,
        onProgress: onProgress,
        sha256: AppConstants.modelSha256,
      );
      if (modelResult != null) return modelResult; // error

      // Download mmproj (phase 2 of 2)
      final mmprojResult = await _downloadFile(
        url: AppConstants.mmprojDownloadUrl,
        destPath: mmprojPath,
        expectedTotal: mmprojTotal,
        priorBytes: modelTotal, // offset so progress is cumulative
        grandTotal: grandTotal,
        onProgress: onProgress,
        sha256: AppConstants.mmprojSha256,
      );
      if (mmprojResult != null) return mmprojResult; // error

      return ModelReady(modelPath: modelPath, mmprojPath: mmprojPath);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        return const ModelError(message: 'Download annullato.');
      }
      return ModelError(message: _friendlyDioError(e));
    } catch (e) {
      return ModelError(message: 'Errore imprevisto: ${e.toString()}');
    }
  }

  // Downloads a single file with resume support.
  // Returns a ModelError on failure, or null on success.
  Future<ModelError?> _downloadFile({
    required String url,
    required String destPath,
    required int expectedTotal,
    required int priorBytes, // bytes already downloaded in prior phases
    required int grandTotal,
    required void Function(int, int, double) onProgress,
    required String sha256,
  }) async {
    final file = File(destPath);
    final existingBytes = file.existsSync() ? file.lengthSync() : 0;

    // Already complete — skip download.
    if (existingBytes > 0 && existingBytes == expectedTotal) {
      onProgress(priorBytes + existingBytes, grandTotal,
          grandTotal > 0 ? (priorBytes + existingBytes) / grandTotal : 1.0);
      return null;
    }

    final headers = <String, dynamic>{};
    if (existingBytes > 0) {
      headers['Range'] = 'bytes=$existingBytes-';
    }

    await _dio.download(
      url,
      destPath,
      cancelToken: _cancelToken,
      deleteOnError: false, // keep partial for resume
      options: Options(headers: headers),
      onReceiveProgress: (received, _) {
        final fileDone = existingBytes + received;
        final totalDone = priorBytes + fileDone;
        final progress =
            grandTotal > 0 ? (totalDone / grandTotal).clamp(0.0, 1.0) : 0.0;
        onProgress(totalDone, grandTotal, progress);
      },
    );

    if (sha256.isNotEmpty) {
      if (!await _verifySha256(file, sha256)) {
        await file.delete();
        return const ModelError(message: 'Il file scaricato è corrotto. Riprova.');
      }
    }

    return null;
  }

  void cancelDownload() {
    _cancelToken?.cancel('Annullato dall\'utente');
  }

  Future<void> deleteModel() async {
    final modelPath = await _getModelPath();
    final mmprojPath = await _getMmprojPath();
    for (final path in [modelPath, mmprojPath]) {
      final file = File(path);
      if (file.existsSync()) await file.delete();
    }
  }

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
