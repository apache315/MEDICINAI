// Riverpod providers for the prescription scan feature

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../services/llm_service.dart';
import '../../../services/model_download_service.dart';
import '../../../services/ocr_service.dart';
import '../../../services/prescription_parser.dart';

part 'scan_provider.g.dart';

@riverpod
OcrService ocrService(OcrServiceRef ref) { // ignore: deprecated_member_use_from_same_package
  final service = MlKitOcrService();
  ref.onDispose(service.dispose);
  return service;
}

// Family provider: runs OCR + LLM on the given image path.
// Automatically handles the case where the model is not yet downloaded.
@riverpod
Future<ParseResult> prescriptionScan(
  PrescriptionScanRef ref, // ignore: deprecated_member_use_from_same_package
  String imagePath,
) async {
  final ocrService = ref.read(ocrServiceProvider);

  LlmService llmService;
  final modelState = ref.read(modelDownloadNotifierProvider).valueOrNull;
  if (modelState is ModelReady) {
    final service = LlamaFuLlmService();
    await service.loadModel(modelState.modelPath);
    ref.onDispose(service.dispose);
    llmService = service;
  } else {
    // Model not downloaded — PrescriptionParser returns OCR text for manual review
    llmService = LlamaFuLlmService(); // isModelReady = false (loadModel not called)
  }

  final parser = PrescriptionParser(
    ocrService: ocrService,
    llmService: llmService,
  );
  return parser.parse(imagePath);
}
