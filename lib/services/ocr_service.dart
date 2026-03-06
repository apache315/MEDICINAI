// OCR service using Google ML Kit Text Recognition (on-device, no cloud, free)
// Extracts text from prescription images before feeding to the LLM.
// OcrService is abstract to allow test doubles without pulling in ML Kit.

import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

// Abstract interface — PrescriptionParser depends on this, not the ML Kit impl.
abstract class OcrService {
  Future<String> extractText(String imagePath);
  Future<void> dispose();
}

// Production implementation using Google ML Kit
class MlKitOcrService implements OcrService {
  MlKitOcrService()
      : _recognizer =
            TextRecognizer(script: TextRecognitionScript.latin);

  final TextRecognizer _recognizer;

  @override
  Future<String> extractText(String imagePath) async {
    final file = File(imagePath);
    if (!file.existsSync()) return '';

    final inputImage = InputImage.fromFile(file);
    try {
      final recognized = await _recognizer.processImage(inputImage);
      return recognized.text;
    } catch (_) {
      return '';
    }
  }

  @override
  Future<void> dispose() => _recognizer.close();
}
