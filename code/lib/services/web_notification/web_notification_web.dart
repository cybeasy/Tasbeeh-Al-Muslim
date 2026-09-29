// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/foundation.dart';

/// Web implementation of WebNotificationManager using HTML5 Notification & DOM events.
class WebNotificationManager {
  static bool get isSupported {
    try {
      return html.Notification.supported;
    } catch (_) {
      return false;
    }
  }

  static String get permission {
    try {
      if (!isSupported) return 'unsupported';
      return html.Notification.permission ?? 'default';
    } catch (_) {
      return 'unsupported';
    }
  }

  static Future<bool> requestPermission() async {
    try {
      if (!isSupported) return false;
      final result = await html.Notification.requestPermission();
      debugPrint("Web Notification permission requested, result: $result");
      return result == 'granted';
    } catch (e) {
      debugPrint("Error requesting web notification permission: $e");
      return false;
    }
  }

  static void showNotification(
    String title,
    String body, {
    String? icon,
    String? tag,
  }) {
    try {
      if (!isSupported) return;
      if (html.Notification.permission != 'granted') {
        debugPrint(
            "Cannot show web notification: permission is ${html.Notification.permission}");
        return;
      }

      final notification = html.Notification(
        title,
        body: body,
        icon: icon ?? 'icons/Icon-192.png?v=2',
        tag: tag ?? 'tasbeeh_zeker',
      );

      notification.onClick.listen((_) {
        try {
          notification.close();
        } catch (_) {}
      });
    } catch (e) {
      debugPrint("Error showing web notification: $e");
    }
  }

  static bool _unlocked = false;

  static void attachAudioUnlockListeners(Function() onUserInteract) {
    if (_unlocked) return;

    void handler(html.Event _) {
      if (_unlocked) return;
      _unlocked = true;
      debugPrint("Web user interaction detected - audio context unlocked.");
      try {
        onUserInteract();
      } catch (e) {
        debugPrint("Error running audio unlock callback: $e");
      }
      try {
        html.window.removeEventListener('click', handler, true);
        html.window.removeEventListener('touchstart', handler, true);
        html.window.removeEventListener('keydown', handler, true);
      } catch (_) {}
    }

    try {
      html.window.addEventListener('click', handler, true);
      html.window.addEventListener('touchstart', handler, true);
      html.window.addEventListener('keydown', handler, true);
    } catch (_) {}
  }
}
