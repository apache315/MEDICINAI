// Unit tests for PrescriptionParser with mocked LLM service.
// OCR is no longer part of the pipeline — images are passed directly to the LLM.

import 'package:flutter_test/flutter_test.dart';
import 'package:mediremind/services/llm_service.dart';
import 'package:mediremind/services/prescription_parser.dart';

// --- Test doubles ---

class _NotReadyLlmService implements LlmService {
  @override
  bool get isModelReady => false;

  @override
  Future<void> loadModel(String modelPath, {String? mmprojPath}) async {}

  @override
  Future<List<ExtractedMedication>> extractMedications(String imagePath) async =>
      [];

  @override
  Future<void> dispose() async {}
}

class _MissingMmprojLlmService implements LlmService {
  @override
  bool get isModelReady => true;

  @override
  Future<void> loadModel(String modelPath, {String? mmprojPath}) async {}

  @override
  Future<List<ExtractedMedication>> extractMedications(String imagePath) async {
    throw StateError(
      'Il proiettore visivo (mmproj) non è disponibile.',
    );
  }

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

    test('emits analyzingWithAi status via callback', () async {
      final statuses = <ParseStatus>[];
      await parser.parse('/fake/path.jpg', onStatus: statuses.add);
      expect(statuses, contains(ParseStatus.analyzingWithAi));
    });
  });

  group('PrescriptionParser — multiple medications', () {
    late PrescriptionParser parser;

    setUp(() {
      parser = PrescriptionParser(
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

  group('PrescriptionParser — LLM returns empty list', () {
    test('returns done status with empty medications', () async {
      final parser = PrescriptionParser(
        llmService: MockLlmService(response: []),
      );
      final result = await parser.parse('/fake/blurry.jpg');
      // Parser succeeds; the review screen handles the empty-list UI case.
      expect(result.isSuccess, isTrue);
      expect(result.medications, isEmpty);
    });
  });

  group('PrescriptionParser — model not ready', () {
    test('returns error when model is not loaded', () async {
      final parser = PrescriptionParser(llmService: _NotReadyLlmService());
      final result = await parser.parse('/fake/path.jpg');
      expect(result.hasError, isTrue);
      expect(result.error, isNotEmpty);
    });
  });

  group('PrescriptionParser — mmproj missing', () {
    test('returns error when mmproj projector is not available', () async {
      final parser = PrescriptionParser(llmService: _MissingMmprojLlmService());
      final result = await parser.parse('/fake/path.jpg');
      expect(result.hasError, isTrue);
      expect(result.error, contains('proiettore visivo'));
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
