// OCR service using Google ML Kit Text Recognition (on-device, no cloud, free)
// Extracts text from prescription images before feeding to the LLM.
// OcrService is abstract to allow test doubles without pulling in ML Kit.

import 'dart:io';

import 'package:flutter/foundation.dart';
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
    debugPrint('[OCR] extractText called, path=$imagePath');
    final file = File(imagePath);
    if (!file.existsSync()) {
      debugPrint('[OCR] ERROR: file does not exist at $imagePath');
      return '';
    }
    debugPrint('[OCR] file exists (${file.lengthSync()} bytes), running MLKit...');

    final inputImage = InputImage.fromFile(file);
    try {
      final recognized = await _recognizer.processImage(inputImage);
      final text = recognized.text;
      debugPrint('[OCR] done — extracted ${text.length} chars');
      debugPrint('[OCR] first 300 chars: ${text.substring(0, text.length.clamp(0, 300))}');
      return text;
    } catch (e, st) {
      debugPrint('[OCR] ERROR: $e\n$st');
      return '';
    }
  }

  @override
  Future<void> dispose() => _recognizer.close();
}
