// PrescriptionParser: orchestrates OCR → LLM → structured medications.
// This is the main entry point for the AI-assisted scan flow.

import 'ocr_service.dart';
import 'llm_service.dart';

enum ParseStatus {
  idle,
  extractingText,
  analyzingWithAi,
  done,
  error,
}

class ParseResult {
  const ParseResult({
    required this.status,
    required this.ocrText,
    required this.medications,
    this.error,
  });

  const ParseResult.idle()
      : status = ParseStatus.idle,
        ocrText = '',
        medications = const [],
        error = null;

  final ParseStatus status;
  final String ocrText;
  final List<ExtractedMedication> medications;
  final String? error;

  bool get isSuccess => status == ParseStatus.done;
  bool get hasError => status == ParseStatus.error;
}

class PrescriptionParser {
  PrescriptionParser({
    required this.ocrService,
    required this.llmService,
  });

  final OcrService ocrService;
  final LlmService llmService;

  // Parses a prescription image, emitting intermediate status via [onStatus].
  // Returns the final ParseResult regardless of success or failure.
  Future<ParseResult> parse(
    String imagePath, {
    void Function(ParseStatus)? onStatus,
  }) async {
    try {
      // Step 1: OCR
      onStatus?.call(ParseStatus.extractingText);
      final ocrText = await ocrService.extractText(imagePath);

      if (ocrText.trim().isEmpty) {
        return const ParseResult(
          status: ParseStatus.error,
          ocrText: '',
          medications: [],
          error:
              'Impossibile leggere il testo dalla ricetta. Riprova con una foto più nitida.',
        );
      }

      if (!llmService.isModelReady) {
        // Model not downloaded yet — return OCR text so user can still
        // manually review and enter medications.
        return ParseResult(
          status: ParseStatus.error,
          ocrText: ocrText,
          medications: const [],
          error:
              'Il modello AI non è ancora disponibile. Testo estratto dalla ricetta disponibile per revisione manuale.',
        );
      }

      // Step 2: LLM extraction
      onStatus?.call(ParseStatus.analyzingWithAi);
      final medications = await llmService.extractMedications(ocrText);

      return ParseResult(
        status: ParseStatus.done,
        ocrText: ocrText,
        medications: medications,
      );
    } catch (e) {
      return ParseResult(
        status: ParseStatus.error,
        ocrText: '',
        medications: const [],
        error: 'Errore durante l\'analisi: ${e.toString()}',
      );
    }
  }
}
