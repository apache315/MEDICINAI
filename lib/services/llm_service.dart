// LLM service interface.
// Abstract interface allows swapping to a real on-device model in the future
// without touching the rest of the codebase.
// Currently uses a no-op stub; wire up a GGUF-capable package when available.

import 'dart:convert';

// --- Domain model ---

class ExtractedMedication {
  const ExtractedMedication({
    required this.name,
    required this.dose,
    required this.unit,
    required this.timesPerDay,
    this.activePrinciple,
    this.specificTimes = const [],
    this.durationDays = -1,
    this.withFood = false,
    this.notes,
  });

  final String name;
  final double dose;
  final String unit;
  final int timesPerDay;
  final String? activePrinciple;
  final List<String> specificTimes;
  // -1 means indefinite
  final int durationDays;
  final bool withFood;
  final String? notes;

  factory ExtractedMedication.fromJson(Map<String, dynamic> json) {
    return ExtractedMedication(
      name: (json['name'] as String?) ?? '',
      activePrinciple: json['active_principle'] as String?,
      dose: (json['dose'] as num?)?.toDouble() ?? 0,
      unit: (json['unit'] as String?) ?? 'mg',
      timesPerDay: (json['times_per_day'] as int?) ?? 1,
      specificTimes:
          ((json['specific_times'] as List<dynamic>?) ?? [])
              .map((e) => e as String)
              .toList(),
      durationDays: (json['duration_days'] as int?) ?? -1,
      withFood: (json['with_food'] as bool?) ?? false,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        if (activePrinciple != null) 'active_principle': activePrinciple,
        'dose': dose,
        'unit': unit,
        'times_per_day': timesPerDay,
        if (specificTimes.isNotEmpty) 'specific_times': specificTimes,
        'duration_days': durationDays,
        'with_food': withFood,
        if (notes != null) 'notes': notes,
      };
}

// --- Abstract interface ---

abstract class LlmService {
  bool get isModelReady;

  Future<void> loadModel(String modelPath);

  Future<List<ExtractedMedication>> extractMedications(String ocrText);

  Future<void> dispose();
}


// --- Stub implementation (no on-device model yet) ---
// Replace this class with a real GGUF-based implementation when a
// compatible Flutter package for llama.cpp becomes available.

class LlamaFuLlmService implements LlmService {
  bool _ready = false;

  @override
  bool get isModelReady => _ready;

  @override
  Future<void> loadModel(String modelPath) async {
    // No-op: real loading will happen here once a compatible package is wired up.
    _ready = true;
  }

  @override
  Future<List<ExtractedMedication>> extractMedications(String ocrText) async {
    // Without a real model, return empty so the review screen shows raw OCR.
    return [];
  }

  @override
  Future<void> dispose() async {
    _ready = false;
  }
}

// Helper kept for future use when a real model response must be parsed.
List<ExtractedMedication> parseLlmJsonResponse(String response) {
  try {
    final start = response.indexOf('{');
    final end = response.lastIndexOf('}');
    if (start == -1 || end == -1 || end < start) return [];

    final decoded = jsonDecode(response.substring(start, end + 1)) as Map<String, dynamic>;
    final meds = (decoded['medications'] as List<dynamic>?) ?? [];
    return meds
        .map((m) => ExtractedMedication.fromJson(m as Map<String, dynamic>))
        .where((m) => m.name.isNotEmpty && m.dose > 0)
        .toList();
  } catch (_) {
    return [];
  }
}

// --- Mock implementation for tests ---

class MockLlmService implements LlmService {
  MockLlmService({this.response = const []});

  final List<ExtractedMedication> response;

  @override
  bool get isModelReady => true;

  @override
  Future<void> loadModel(String modelPath) async {}

  @override
  Future<List<ExtractedMedication>> extractMedications(String ocrText) async =>
      response;

  @override
  Future<void> dispose() async {}
}
