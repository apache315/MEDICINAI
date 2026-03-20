# MediRemind — AI Medication Reminder

App Flutter per promemoria farmaci con riconoscimento automatico delle ricette mediche tramite AI on-device. Progettata per anziani e caregiver: font grandi, interfaccia semplice, nessun server esterno.

---

## Cosa fa

- **Scansiona una ricetta** con la fotocamera → l'AI estrae automaticamente i farmaci, dosi e frequenze
- **Crea promemoria** con allarmi precisi che suonano anche a schermo spento
- **Gestisce i farmaci attivi**: elenco, dettaglio, modifica orari, storico assunzioni
- **Tutto on-device**: nessun dato inviato a cloud, nessun account, nessun abbonamento

---

## Stack tecnico

| Layer | Tecnologia |
|---|---|
| UI | Flutter 3.41+ / Dart 3.11+ |
| State management | Riverpod 2 + riverpod_generator |
| Navigation | go_router |
| Database locale | Drift (SQLite) |
| Notifiche | flutter_local_notifications (AlarmClock mode) |
| AI vision | fllama (llama.cpp) + Qwen3.5-0.8B-Q4_K_M |
| OCR fallback | Google ML Kit Text Recognition (on-device) |

---

## Integrazione fllama

### Cos'è fllama

[fllama](https://github.com/Telosnex/fllama) è un wrapper Flutter attorno a **llama.cpp** — il runtime C++ che permette di eseguire modelli LLM localmente su Android/iOS senza GPU dedicata. Fornisce API Dart compatibili OpenAI (`OpenAiRequest`, `Message`, `Tool`) e gestisce thread, context window e inference in background.

### Perché fllama e non un'API cloud

| | fllama (on-device) | API cloud (OpenAI, Gemini…) |
|---|---|---|
| Privacy | I dati della ricetta non escono dal telefono | Immagini inviate a server esterni |
| Costo | Zero, sempre | A consumo / abbonamento |
| Funziona offline | Sì | No |
| Latenza | 10–30s (CPU) | 1–3s |
| Accuratezza | Buona su testo stampato | Ottima |

Per un'app medica usata da anziani, privacy e funzionamento offline erano requisiti non negoziabili.

### Il modello: Qwen3.5-0.8B

Modello scelto: **[Qwen3.5-0.8B-Q4_K_M](https://huggingface.co/unsloth/Qwen3.5-0.8B-GGUF)** (~520MB quantizzato 4-bit).

Caratteristiche rilevanti per questo progetto:
- **Multimodale nativo**: supporta immagini tramite vision projector (`mmproj-F16.gguf`, ~205MB)
- **201 lingue** incluso italiano
- **Tool calling**: supporta grammar-constrained generation per output JSON strutturato garantito
- Gira su CPU arm64 con ~1.5GB RAM → compatibile con telefoni Android comuni

Il modello viene scaricato al primo avvio dall'app (da HuggingFace), non è incluso nel repo.

### Cosa abbiamo sviluppato

#### 1. Tool calling per output strutturato garantito

Il problema principale con i modelli piccoli è che producono testo libero invece di JSON pulito. La soluzione è usare il **tool calling con grammar enforcement** di llama.cpp: si passa uno schema JSON al modello e llama.cpp usa una grammatica context-free per costringere l'output a rispettare esattamente quello schema — zero errori di parsing.

```dart
// lib/services/llm_service.dart
final request = OpenAiRequest(
  modelPath: modelPath,
  mmprojPath: mmprojPath,         // vision projector per le immagini
  temperature: 0.05,              // deterministico
  tools: [
    Tool(
      name: 'extract_medications',
      description: '...',
      jsonSchema: _toolSchema,    // JSON Schema con name, dose, unit, times_per_day...
    ),
  ],
  toolChoice: ToolChoice.required, // forza l'uso del tool (no testo libero)
  ...
);
```

Il callback di `fllamaChat` restituisce due parametri: `(String rawText, String openaiJson, bool done)`. Il secondo è la risposta in formato OpenAI con `choices[0].message.tool_calls` — lì si trovano gli argomenti strutturati del tool.

#### 2. Immagini come base64 data URI (LLaVA-style)

fllama riconosce le immagini cercando il pattern `<img src="data:image/...;base64,...">` nel testo del messaggio utente. Viene poi estratta e caricata nel context del modello tramite il vision projector.

```dart
final base64Image = base64Encode(await File(imagePath).readAsBytes());
final userText = '<img src="data:image/jpeg;base64,$base64Image">\n\nEstrai i farmaci...';
```

#### 3. Fallback OCR → LLM testuale

Se l'immagine non è riconoscibile visivamente, ML Kit estrae il testo OCR e lo passa come testo puro al modello (senza immagine). Questo migliora l'affidabilità su ricette con scrittura difficile.

---

## Notifiche: AlarmClock mode

Su Android, le notifiche standard vengono soppresse da MIUI/EMUI/OneUI quando l'app è chiusa. Usiamo `AndroidScheduleMode.alarmClock` che chiama `AlarmManager.setAlarmClock()` — la stessa API usata dalle sveglie di sistema, impossibile da bloccare dall'ottimizzazione batteria.

Richiede il permesso `SCHEDULE_EXACT_ALARM` (Android 12) o `USE_EXACT_ALARM` (Android 13+), richiesto esplicitamente all'utente dalla schermata Impostazioni promemoria.

---

## Build

### Requisiti

- Flutter 3.29+ (testato su 3.41.4)
- Android NDK (gestito automaticamente da Flutter)
- Dispositivo Android arm64 (il modello AI gira solo su arm64)

### Setup

```bash
git clone https://github.com/apache315/MEDICINAI.git
cd MEDICINAI
flutter pub get
```

Il codice generato (Drift, Riverpod) è già committato. Se vuoi rigenerarlo:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Build APK debug

```bash
flutter build apk --debug
```

### Note arm64

`android/app/build.gradle` ha `abiFilters 'arm64-v8a'` perché fllama compila solo per arm64. Gli emulatori x86_64 non sono supportati — usa un dispositivo fisico.

### Modello AI

Al primo avvio l'app scarica automaticamente i modelli da HuggingFace (~725MB totali):
- `Qwen3.5-0.8B-Q4_K_M.gguf` (~520MB)
- `mmproj-F16.gguf` (~205MB)

---

## Struttura del progetto

```
lib/
├── core/
│   ├── constants/      # AppConstants (canali notifica, font size, URL modelli)
│   ├── router/         # go_router con route guards
│   └── theme/          # tema accessibile (font grandi, contrasto elevato)
├── database/
│   ├── daos/           # RemindersDao, MedicationsDao, HistoryDao
│   └── app_database.dart  # schema Drift
├── features/
│   ├── home/           # dashboard farmaci attivi
│   ├── medications/    # aggiunta manuale, dettaglio, modifica orari allarme
│   ├── scan_prescription/  # fotocamera → AI → review → salvataggio
│   ├── history/        # storico assunzioni
│   ├── reminders/      # impostazioni allarmi, test notifica, stato permessi
│   ├── model_download/ # download/aggiornamento modello AI
│   └── onboarding/     # primo avvio
└── services/
    ├── llm_service.dart          # interfaccia + implementazione fllama
    ├── notification_service.dart # scheduling AlarmClock + permessi
    ├── ocr_service.dart          # ML Kit OCR
    ├── prescription_parser.dart  # parsing farmaci dal testo OCR
    └── model_download_service.dart  # download + verifica SHA256
```

---

## Contribuire

Pull request benvenute. Per modifiche alla pipeline AI (llm_service.dart, prescription_parser.dart) includere test in `test/services/`.
