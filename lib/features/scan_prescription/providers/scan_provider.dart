// Riverpod providers for the prescription scan feature

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../services/llm_service.dart';
import '../../../services/model_download_service.dart';
import '../../../services/prescription_parser.dart';
import 'scan_log_provider.dart';

part 'scan_provider.g.dart';

// Family provider: runs multimodal inference directly on the given image path.
// Uses await on .future to wait for the async model state (fixes race condition
// where autoDispose rebuilds modelDownloadNotifierProvider and .valueOrNull is null).
@riverpod
Future<ParseResult> prescriptionScan(
  PrescriptionScanRef ref, // ignore: deprecated_member_use_from_same_package
  String imagePath,
) async {
  // Escape the synchronous build phase before modifying other providers.
  // Riverpod forbids modifying StateNotifierProvider during a provider's sync init.
  await Future<void>.value();

  final log = ref.read(scanLogProvider.notifier);
  log.reset();

  // Step 1: wait for model state (await .future avoids AsyncLoading race)
  log.add('Verifica modello AI');
  final modelState = await ref.read(modelDownloadNotifierProvider.future);
  debugPrint('[SCAN] modelState=$modelState (type=${modelState.runtimeType})');

  LlmService llmService;
  if (modelState is ModelReady) {
    log.completeLast(detail: 'Pronto');
    log.add('Caricamento modello in memoria');
    debugPrint('[SCAN] model ready — loading with mmproj=${modelState.mmprojPath}');
    final service = LlamaFuLlmService();
    await service.loadModel(modelState.modelPath, mmprojPath: modelState.mmprojPath);
    ref.onDispose(service.dispose);
    llmService = service;
    log.completeLast();
  } else {
    final msg = 'Stato modello inatteso: ${modelState.runtimeType}';
    log.errorLast(msg);
    debugPrint('[SCAN] model NOT ready: $msg');
    llmService = LlamaFuLlmService(); // isModelReady = false → parse returns error
  }

  // Step 2: image path confirmed
  log.add('Foto caricata');
  log.completeLast(detail: imagePath.split('/').last);

  // Step 3: send to multimodal AI
  log.add('Invio immagine al modello AI (30–120 sec)…');
  debugPrint('[SCAN] prescriptionScan called, imagePath=$imagePath');

  final parser = PrescriptionParser(llmService: llmService);
  final result = await parser.parse(imagePath);

  // Step 4: result
  if (result.hasError) {
    log.errorLast(result.error ?? 'Errore sconosciuto');
  } else {
    log.completeLast(detail: 'Risposta ricevuta');
    log.add('Farmaci estratti: ${result.medications.length}');
    log.completeLast();
  }

  debugPrint(
    '[SCAN] parse complete: status=${result.status}, '
    'meds=${result.medications.length}, error=${result.error}',
  );
  return result;
}
