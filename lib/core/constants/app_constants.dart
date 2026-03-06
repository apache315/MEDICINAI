// Application-wide constants

class AppConstants {
  AppConstants._();

  // Model info
  static const String modelFileName = 'qwen3.5-0.8b-instruct-q4_k_m.gguf';
  static const String modelVersion = '1';
  // URL will be updated once the official Qwen3.5-0.8B GGUF is published
  static const String modelDownloadUrl =
      'https://huggingface.co/unsloth/Qwen3.5-0.8B-GGUF/resolve/main/Qwen3.5-0.8B-Q4_K_M.gguf';
  // SHA256 hash: update after verifying the downloaded file
  static const String modelSha256 = '';

  // Database
  static const String databaseFileName = 'mediremind.db';
  static const int databaseVersion = 1;

  // Settings keys (shared_preferences)
  static const String keyModelDownloaded = 'model_downloaded';
  static const String keyModelVersion = 'model_version';
  static const String keyOnboardingDone = 'onboarding_done';

  // Notification channels
  static const String notificationChannelId = 'mediremind_medications';
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
