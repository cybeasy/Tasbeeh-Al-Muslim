import 'web_notification_stub.dart'
    if (dart.library.html) 'web_notification_web.dart';

/// Cross-platform wrapper for Web HTML5 Notifications and AudioContext unlock.
class WebNotification {
  static bool get isSupported => WebNotificationManager.isSupported;

  static String get permission => WebNotificationManager.permission;

  static bool get isGranted => permission == 'granted';

  static Future<bool> requestPermission() =>
      WebNotificationManager.requestPermission();

  static void show(
    String title,
    String body, {
    String? icon,
    String? tag,
  }) =>
      WebNotificationManager.showNotification(
        title,
        body,
        icon: icon,
        tag: tag,
      );

  static void attachAudioUnlock(Function() onUserInteract) =>
      WebNotificationManager.attachAudioUnlockListeners(onUserInteract);
}
