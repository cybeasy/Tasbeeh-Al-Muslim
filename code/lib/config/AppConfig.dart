/**
 * Global Application Configuration & Environment Settings
 * Tasbeeh Al Muslim
 */
class AppConfig {
  AppConfig._();

  // 1. Environment & Domains (Configurable via --dart-define or defaults)
  static const String domain = String.fromEnvironment(
    'APP_DOMAIN',
    defaultValue: 'cybeasy.com',
  );

  static const String apiBasePath = String.fromEnvironment(
    'API_BASE_PATH',
    defaultValue: '/Tasbeeh-Al-Muslim/api/v3',
  );

  static const String appBasePath = String.fromEnvironment(
    'APP_BASE_PATH',
    defaultValue: '/Tasbeeh-Al-Muslim/app',
  );

  // 2. Computed URLs
  static String get apiBaseUrl => 'https://$domain$apiBasePath';
  static String get appUrl => 'https://$domain$appBasePath';
  static String get landingUrl => 'https://$domain/Tasbeeh-Al-Muslim/';

  // 3. API Endpoints
  static String get quranApiUrl => '$apiBaseUrl/mp3Quran_ver2.php';
  static String get radioApiUrl => '$apiBaseUrl/radio.php';
  static String get tafserApiUrl => '$apiBaseUrl/mp3Quran_tafser.php';
  static String get aboutApiUrl => '$apiBaseUrl/about.php';
  static String get supportApiUrl => '$apiBaseUrl/support.php';

  // 4. Security & App Identifiers
  static const String appVersion = '3.0.0';
  static const String clientName = 'Tasbeeh-Al-Muslim';
}
