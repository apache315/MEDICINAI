// Unit tests for PrescriptionParser with mocked OCR and LLM services

import 'package:flutter_test/flutter_test.dart';
import 'package:mediremind/services/llm_service.dart';
import 'package:mediremind/services/ocr_service.dart';
import 'package:mediremind/services/prescription_parser.dart';

// --- Test doubles ---

class FakeOcrService implements OcrService {
  FakeOcrService(this._text);
  final String _text;

  @override
  Future<String> extractText(String imagePath) async => _text;

  @override
  Future<void> dispose() async {}
}

class _AlwaysNotReadyMock implements LlmService {
  @override
  bool get isModelReady => false;

  @override
  Future<void> loadModel(String modelPath) async {}

  @override
  Future<List<ExtractedMedication>> extractMedications(String ocrText) async =>
      [];

  @override
  Future<void> dispose() async {}
}

// --- Test data ---

const _singleMedResponse = [
  ExtractedMedication(
    name: 'Aspirina',
    dose: 100,
    unit: 'mg',
    timesPerDay: 1,
    specificTimes: ['08:00'],
    durationDays: 30,
  ),
];

const _multiMedResponse = [
  ExtractedMedication(
    name: 'Atorvastatina',
    dose: 20,
    unit: 'mg',
    timesPerDay: 1,
    durationDays: -1,
  ),
  ExtractedMedication(
    name: 'Ramipril',
    dose: 5,
    unit: 'mg',
    timesPerDay: 1,
    durationDays: -1,
  ),
  ExtractedMedication(
    name: 'Metformina',
    dose: 500,
    unit: 'mg',
    timesPerDay: 2,
    durationDays: -1,
  ),
];

void main() {
  group('PrescriptionParser — single medication', () {
    late PrescriptionParser parser;

    setUp(() {
      parser = PrescriptionParser(
        ocrService:
            FakeOcrService('Aspirina 100mg 1 volta al giorno per 30 giorni'),
        llmService: MockLlmService(response: _singleMedResponse),
      );
    });

    test('returns done status on success', () async {
      final result = await parser.parse('/fake/path.jpg');
      expect(result.isSuccess, isTrue);
    });

    test('extracts 1 medication', () async {
      final result = await parser.parse('/fake/path.jpg');
      expect(result.medications.length, equals(1));
    });

    test('medication has correct name and dose', () async {
      final result = await parser.parse('/fake/path.jpg');
      final med = result.medications.first;
      expect(med.name, equals('Aspirina'));
      expect(med.dose, equals(100));
      expect(med.unit, equals('mg'));
    });

    test('tracks status transitions via callback', () async {
      final statuses = <ParseStatus>[];
      await parser.parse('/fake/path.jpg', onStatus: statuses.add);
      expect(statuses, contains(ParseStatus.extractingText));
      expect(statuses, contains(ParseStatus.analyzingWithAi));
    });
  });

  group('PrescriptionParser — multiple medications', () {
    late PrescriptionParser parser;

    setUp(() {
      parser = PrescriptionParser(
        ocrService: FakeOcrService(
          'Atorvastatina 20mg die\nRamipril 5mg die\nMetformina 500mg 2 volte die',
        ),
        llmService: MockLlmService(response: _multiMedResponse),
      );
    });

    test('extracts 3 medications', () async {
      final result = await parser.parse('/fake/path.jpg');
      expect(result.medications.length, equals(3));
    });

    test('chronic medications have durationDays -1', () async {
      final result = await parser.parse('/fake/path.jpg');
      expect(result.medications.every((m) => m.durationDays == -1), isTrue);
    });

    test('Metformina has timesPerDay = 2', () async {
      final result = await parser.parse('/fake/path.jpg');
      final metformina =
          result.medications.firstWhere((m) => m.name == 'Metformina');
      expect(metformina.timesPerDay, equals(2));
    });
  });

  group('PrescriptionParser — empty OCR (unreadable image)', () {
    late PrescriptionParser parser;

    setUp(() {
      parser = PrescriptionParser(
        ocrService: FakeOcrService(''),
        llmService: MockLlmService(response: []),
      );
    });

    test('returns error when OCR extracts no text', () async {
      final result = await parser.parse('/fake/blurry.jpg');
      expect(result.hasError, isTrue);
    });

    test('error message is non-empty', () async {
      final result = await parser.parse('/fake/blurry.jpg');
      expect(result.error, isNotEmpty);
    });
  });

  group('PrescriptionParser — AI not ready', () {
    late PrescriptionParser parser;

    setUp(() {
      parser = PrescriptionParser(
        ocrService: FakeOcrService('Aspirina 100mg'),
        llmService: _AlwaysNotReadyMock(),
      );
    });

    test('returns error but includes OCR text for manual review', () async {
      final result = await parser.parse('/fake/path.jpg');
      expect(result.hasError, isTrue);
      expect(result.ocrText, equals('Aspirina 100mg'));
    });
  });

  group('ExtractedMedication.fromJson', () {
    test('parses complete JSON correctly', () {
      final med = ExtractedMedication.fromJson({
        'name': 'Lansoprazolo',
        'active_principle': 'Lansoprazolo',
        'dose': 30,
        'unit': 'mg',
        'times_per_day': 1,
        'specific_times': ['07:00'],
        'duration_days': 14,
        'with_food': false,
        'notes': 'Assumere prima dei pasti',
      });
      expect(med.name, equals('Lansoprazolo'));
      expect(med.dose, equals(30));
      expect(med.specificTimes, equals(['07:00']));
      expect(med.durationDays, equals(14));
    });

    test('missing optional fields get default values', () {
      final med = ExtractedMedication.fromJson({
        'name': 'Ibuprofene',
        'dose': 400,
        'unit': 'mg',
        'times_per_day': 3,
      });
      expect(med.activePrinciple, isNull);
      expect(med.durationDays, equals(-1));
      expect(med.withFood, isFalse);
      expect(med.specificTimes, isEmpty);
    });

    test('toJson / fromJson round-trip preserves all fields', () {
      const original = ExtractedMedication(
        name: 'Cardioaspirina',
        dose: 100,
        unit: 'mg',
        timesPerDay: 1,
        activePrinciple: 'Acido acetilsalicilico',
        specificTimes: ['08:00'],
        durationDays: -1,
        withFood: true,
        notes: 'Con abbondante acqua',
      );
      final json = original.toJson();
      final restored = ExtractedMedication.fromJson(json);
      expect(restored.name, equals(original.name));
      expect(restored.dose, equals(original.dose));
      expect(restored.activePrinciple, equals(original.activePrinciple));
      expect(restored.specificTimes, equals(original.specificTimes));
      expect(restored.withFood, equals(original.withFood));
    });
  });
}
