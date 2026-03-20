// Application-wide constants

class AppConstants {
  AppConstants._();

  // --- LLM model: Qwen3.5-0.8B Q4_K_M ---
  // Source: https://huggingface.co/unsloth/Qwen3.5-0.8B-GGUF
  static const String modelFileName = 'Qwen3.5-0.8B-Q4_K_M.gguf';
  static const String modelVersion = '1';
  static const String modelDownloadUrl =
      'https://huggingface.co/unsloth/Qwen3.5-0.8B-GGUF/resolve/main/Qwen3.5-0.8B-Q4_K_M.gguf';
  // Fill in SHA256 once the file is stable to enable integrity verification.
  static const String modelSha256 = '';

  // --- Vision projector (mmproj) for multimodal inference ---
  // Must be downloaded alongside the model. ~205 MB.
  static const String mmprojFileName = 'mmproj-F16.gguf';
  static const String mmprojDownloadUrl =
      'https://huggingface.co/unsloth/Qwen3.5-0.8B-GGUF/resolve/main/mmproj-F16.gguf';
  static const String mmprojSha256 = '';

  // Database
  static const String databaseFileName = 'mediremind.db';
  static const int databaseVersion = 1;

  // Settings keys (shared_preferences)
  static const String keyModelDownloaded = 'model_downloaded';
  static const String keyModelVersion = 'model_version';
  static const String keyOnboardingDone = 'onboarding_done';

  // Notification channels
  // v2: bumped to force a fresh channel with Importance.max (Android caches channels)
  static const String notificationChannelId = 'mediremind_medications_v2';
  static const String notificationChannelName = 'Promemoria Farmaci';
  static const String notificationChannelDescription =
      'Notifiche per ricordare di prendere i farmaci';

  // Notification IDs range: each reminder gets a deterministic int ID
  static const int notificationIdBase = 10000;

  // Interaction DB
  static const String interactionDbPath = 'assets/interaction_db/interactions.json';

  // UI
  static const double minButtonHeight = 56.0;
  static const double minButtonWidth = 56.0;
  static const double cardBorderRadius = 16.0;
  static const double bodyFontSize = 18.0;
  static const double labelFontSize = 16.0;
  static const double titleFontSize = 22.0;
  static const double headlineFontSize = 26.0;
}
