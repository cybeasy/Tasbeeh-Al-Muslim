/// Stub implementation for non-web platforms (Android, iOS, macOS, Windows, Linux).
class WebNotificationManager {
  static bool get isSupported => false;

  static String get permission => 'unsupported';

  static Future<bool> requestPermission() async => false;

  static void showNotification(
    String title,
    String body, {
    String? icon,
    String? tag,
  }) {}

  static void attachAudioUnlockListeners(Function() onUserInteract) {}
}
