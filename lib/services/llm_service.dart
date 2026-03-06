// LLM service interface and llamafu implementation.
// Abstract interface allows swapping to a vision model in the future
// without touching the rest of the codebase.
//
// llamafu 0.1.0 uses complete() + prompt formatting for structured output.
// We embed the JSON schema in the system prompt and parse the response.

import 'dart:convert';

import 'package:llamafu/llamafu.dart';

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

// --- System prompt with embedded JSON schema ---

const _systemPromptWithSchema = '''
Sei un assistente medico preciso. Analizza il testo di una ricetta medica italiana.
Rispondi SOLO con un oggetto JSON valido nel formato seguente, senza testo aggiuntivo:

{
  "medications": [
    {
      "name": "Nome farmaco",
      "active_principle": "Principio attivo (opzionale)",
      "dose": 100,
      "unit": "mg",
      "times_per_day": 1,
      "specific_times": ["08:00"],
      "duration_days": 30,
      "with_food": false,
      "notes": "Note aggiuntive (opzionale)"
    }
  ]
}

Valori validi per "unit": mg, mcg, g, ml, UI, gocce, compresse, capsule, bustine.
"duration_days": -1 se la durata non e specificata.
Non inventare informazioni. Se un campo non e chiaro, usa valori di default.
Rispondi SOLO con il JSON, nessuna altra parola.
''';

// --- llamafu implementation ---

class LlamaFuLlmService implements LlmService {
  Llamafu? _llamafu;

  @override
  bool get isModelReady => _llamafu != null;

  @override
  Future<void> loadModel(String modelPath) async {
    _llamafu = await Llamafu.init(
      modelPath: modelPath,
      contextSize: 4096,
      threads: 4,
    );
  }

  @override
  Future<List<ExtractedMedication>> extractMedications(String ocrText) async {
    final llm = _llamafu;
    if (llm == null) return [];

    // Build prompt using Chat class for proper conversation formatting
    final chat = Chat(
      llm,
      config: const ChatConfig(
        systemPrompt: _systemPromptWithSchema,
        maxTokens: 1024,
        temperature: 0.05, // Very low for deterministic JSON output
        topK: 10,
        topP: 0.8,
      ),
    );

    final response = await chat.send(
      'Estrai i farmaci dalla seguente ricetta:\n\n$ocrText',
    );

    return _parseJsonResponse(response);
  }

  List<ExtractedMedication> _parseJsonResponse(String response) {
    try {
      final jsonStr = _extractJson(response);
      if (jsonStr == null) return [];

      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
      final meds = (decoded['medications'] as List<dynamic>?) ?? [];

      return meds
          .map((m) => ExtractedMedication.fromJson(m as Map<String, dynamic>))
          .where((m) => m.name.isNotEmpty && m.dose > 0)
          .toList();
    } catch (_) {
      return [];
    }
  }

  // Extracts the first valid JSON object from a (possibly dirty) response.
  String? _extractJson(String text) {
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start == -1 || end == -1 || end < start) return null;
    return text.substring(start, end + 1);
  }

  @override
  Future<void> dispose() async {
    _llamafu?.close();
    _llamafu = null;
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
