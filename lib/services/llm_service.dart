// LLM service interface + fllama implementation.
// Uses fllama with OpenAiRequest tool calling: grammar-constrained output
// ensures valid structured JSON even on small models.
// Image is embedded as base64 data URI in user message (LLaVA-style).

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:fllama/fllama.dart';

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

  Future<void> loadModel(String modelPath, {String? mmprojPath});
  Future<List<ExtractedMedication>> extractMedications(String imagePath);
  Future<void> dispose();
}

// --- System prompt (Italian, concise, no JSON examples to avoid copying) ---

const _systemPrompt =
    'Sei un assistente medico. Osserva attentamente l\'immagine della ricetta e leggi il testo. '
    'Estrai tutti i farmaci indicati e chiama la funzione extract_medications con i dati che leggi. '
    'Leggi i nomi esatti dalla ricetta. Non inventare nomi, dosi o frequenze.';

// --- Tool schema for extract_medications ---

const _toolSchema = '''
{
  "type": "object",
  "required": ["medications"],
  "properties": {
    "medications": {
      "type": "array",
      "description": "Lista dei farmaci estratti dalla ricetta",
      "items": {
        "type": "object",
        "required": ["name", "dose", "unit", "times_per_day"],
        "properties": {
          "name":           {"type": "string",  "description": "Nome del farmaco come scritto nella ricetta"},
          "active_principle":{"type": "string", "description": "Principio attivo se diverso dal nome commerciale"},
          "dose":           {"type": "number",  "description": "Quantita della dose numerica (es. 100, 500, 0.5)"},
          "unit":           {"type": "string",  "description": "Unita di misura: mg, g, ml, mcg, UI, gocce"},
          "times_per_day":  {"type": "integer", "description": "Numero di somministrazioni al giorno"},
          "specific_times": {"type": "array",   "description": "Orari specifici se indicati es 08:00 20:00", "items": {"type": "string"}},
          "duration_days":  {"type": "integer", "description": "Durata terapia in giorni, -1 se non specificata"},
          "with_food":      {"type": "boolean", "description": "True se da prendere con il cibo"},
          "notes":          {"type": "string",  "description": "Note aggiuntive es al mattino prima di dormire"}
        }
      }
    }
  }
}
''';

// --- fllama implementation ---

class LlamaFuLlmService implements LlmService {
  String? _modelPath;
  String? _mmprojPath;

  @override
  bool get isModelReady => _modelPath != null;

  @override
  Future<void> loadModel(String modelPath, {String? mmprojPath}) async {
    debugPrint('[LLM] loadModel: $modelPath');
    debugPrint('[LLM] mmprojPath: ${mmprojPath ?? "non impostato"}');
    _modelPath = modelPath;
    _mmprojPath = mmprojPath;
  }

  @override
  Future<List<ExtractedMedication>> extractMedications(String imagePath) async {
    debugPrint('[LLM] extractMedications, imagePath=$imagePath');

    final modelPath = _modelPath;
    if (modelPath == null) {
      debugPrint('[LLM] model not loaded, returning []');
      return [];
    }

    final mmprojPath = _mmprojPath;
    if (mmprojPath == null) {
      throw StateError(
        'Il proiettore visivo (mmproj) non è disponibile. '
        'Assicurati che mmproj-F16.gguf sia stato scaricato insieme al modello.',
      );
    }

    final imageBytes = await File(imagePath).readAsBytes();
    final base64Image = base64Encode(imageBytes);
    final userText =
        '<img src="data:image/jpeg;base64,$base64Image">\n\n'
        'Estrai i farmaci dalla ricetta in questa immagine.';
    debugPrint('[LLM] immagine codificata: ${imageBytes.length} bytes');

    final request = OpenAiRequest(
      modelPath: modelPath,
      mmprojPath: mmprojPath,
      numGpuLayers: 99,
      temperature: 0.05,
      maxTokens: 512,
      contextSize: 4096,
      messages: [
        Message(Role.system, _systemPrompt),
        Message(Role.user, userText),
      ],
      tools: [
        Tool(
          name: 'extract_medications',
          description: 'Estrae la lista strutturata dei farmaci dalla ricetta medica',
          jsonSchema: _toolSchema,
        ),
      ],
      toolChoice: ToolChoice.required,
      logger: (msg) {
        final truncated = msg.length > 500 ? '${msg.substring(0, 500)}…[truncated]' : msg;
        debugPrint('[FLLAMA_C++] $truncated');
      },
    );

    // The second callback parameter is the OpenAI-format JSON response.
    // When tool calling succeeds it contains choices[0].message.tool_calls.
    // Fall back to the raw response text if the JSON is empty.
    final completer = Completer<(String raw, String openaiJson)>();
    debugPrint('[LLM] chiamata fllamaChat con tool calling...');
    fllamaChat(request, (response, openaiJson, done) {
      if (done) completer.complete((response, openaiJson));
    });

    final (raw, openaiJson) = await completer.future;
    debugPrint('[LLM] risposta raw length=${raw.length}');
    debugPrint('[LLM] openaiJson length=${openaiJson.length}');
    if (raw.isNotEmpty) {
      for (var i = 0; i < raw.length; i += 900) {
        debugPrint('[LLM_RAW] ${raw.substring(i, i + 900 > raw.length ? raw.length : i + 900)}');
      }
    }

    final meds = _parseToolCallResponse(openaiJson) ?? parseLlmJsonResponse(raw);
    debugPrint('[LLM] farmaci estratti: ${meds.length}');
    return meds;
  }

  @override
  Future<void> dispose() async {
    _modelPath = null;
    _mmprojPath = null;
  }
}

// Parses the OpenAI-format tool call response from fllama.
// Returns null if the response doesn't contain a valid tool call.
List<ExtractedMedication>? _parseToolCallResponse(String openaiJson) {
  if (openaiJson.isEmpty) return null;
  try {
    final decoded = jsonDecode(openaiJson) as Map<String, dynamic>;
    final choices = decoded['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) return null;

    final message = choices[0]['message'] as Map<String, dynamic>?;
    if (message == null) return null;

    final toolCalls = message['tool_calls'] as List<dynamic>?;
    if (toolCalls == null || toolCalls.isEmpty) return null;

    final args = jsonDecode(
      toolCalls[0]['function']['arguments'] as String,
    ) as Map<String, dynamic>;

    debugPrint('[LLM] tool call arguments parsed OK');
    final meds = (args['medications'] as List<dynamic>? ?? [])
        .map((m) => ExtractedMedication.fromJson(m as Map<String, dynamic>))
        .toList();

    for (final m in meds) {
      debugPrint('[LLM] tool item: name="${m.name}" dose=${m.dose} unit="${m.unit}"');
    }
    return meds.where((m) => m.name.isNotEmpty).toList();
  } catch (e) {
    debugPrint('[LLM] _parseToolCallResponse exception: $e');
    return null;
  }
}

// Fallback: extracts JSON from raw LLM text ignoring extra tokens.
List<ExtractedMedication> parseLlmJsonResponse(String response) {
  try {
    final start = response.indexOf('{');
    final end = response.lastIndexOf('}');
    if (start == -1 || end == -1 || end < start) return [];

    final decoded = jsonDecode(response.substring(start, end + 1)) as Map<String, dynamic>;
    final meds = (decoded['medications'] as List<dynamic>?) ?? [];
    final parsed = meds
        .map((m) => ExtractedMedication.fromJson(m as Map<String, dynamic>))
        .toList();
    debugPrint('[LLM] fallback parsed ${parsed.length} items');
    for (final m in parsed) {
      debugPrint('[LLM] item: name="${m.name}" dose=${m.dose} unit="${m.unit}"');
    }
    return parsed.where((m) => m.name.isNotEmpty).toList();
  } catch (e) {
    debugPrint('[LLM] parseLlmJsonResponse exception: $e');
    return [];
  }
}

// --- Mock per i test ---

class MockLlmService implements LlmService {
  MockLlmService({this.response = const []});
  final List<ExtractedMedication> response;

  @override
  bool get isModelReady => true;

  @override
  Future<void> loadModel(String modelPath, {String? mmprojPath}) async {}

  @override
  Future<List<ExtractedMedication>> extractMedications(String imagePath) async => response;

  @override
  Future<void> dispose() async {}
}
