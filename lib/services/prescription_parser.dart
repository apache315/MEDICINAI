// PrescriptionParser: passes the prescription image directly to the LLM
// for multimodal extraction. OCR is no longer needed.

import 'llm_service.dart';

enum ParseStatus {
  idle,
  analyzingWithAi,
  done,
  error,
}

class ParseResult {
  const ParseResult({
    required this.status,
    required this.medications,
    this.error,
  });

  const ParseResult.idle()
      : status = ParseStatus.idle,
        medications = const [],
        error = null;

  final ParseStatus status;
  final List<ExtractedMedication> medications;
  final String? error;

  bool get isSuccess => status == ParseStatus.done;
  bool get hasError => status == ParseStatus.error;
}

class PrescriptionParser {
  PrescriptionParser({required this.llmService});

  final LlmService llmService;

  // Passes [imagePath] directly to the multimodal LLM.
  // Emits intermediate status via [onStatus].
  Future<ParseResult> parse(
    String imagePath, {
    void Function(ParseStatus)? onStatus,
  }) async {
    try {
      if (!llmService.isModelReady) {
        return const ParseResult(
          status: ParseStatus.error,
          medications: [],
          error:
              'Il modello AI non è ancora disponibile. Scarica il modello dalla schermata principale.',
        );
      }

      onStatus?.call(ParseStatus.analyzingWithAi);
      final medications = await llmService.extractMedications(imagePath);

      return ParseResult(
        status: ParseStatus.done,
        medications: medications,
      );
    } on StateError catch (e) {
      // Raised when mmproj is missing or chat handler is incompatible.
      return ParseResult(
        status: ParseStatus.error,
        medications: const [],
        error: e.message,
      );
    } on UnsupportedError catch (e) {
      return ParseResult(
        status: ParseStatus.error,
        medications: const [],
        error: e.message ?? 'Modello non supportato.',
      );
    } catch (e) {
      return ParseResult(
        status: ParseStatus.error,
        medications: const [],
        error: 'Errore durante l\'analisi: ${e.toString()}',
      );
    }
  }
}
