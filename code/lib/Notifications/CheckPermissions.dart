import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tsbeh/Notifications/Local/NotificationService.dart';

class NotificationPermissionChecker {
  NotificationPermissionChecker(this._fln);

  final FlutterLocalNotificationsPlugin _fln;

  static void check(BuildContext context) async {
    if (kIsWeb) return;
    final checker = NotificationPermissionChecker(
      flutterLocalNotificationsPlugin,
    );

    // 1) Just check (no UI)
    final enabled = await checker.isEnabled();

    // 2) Check and, if disabled, show alert → Settings
    final ok = await checker.ensureEnabledOrPrompt(context);
    if (!ok) {
      // still disabled; show a banner/snackbar if you like
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('برجاء تفعيل الاشعارات لتشغيل الاذكار')),
        );
      }
    }
  }

  /// Pure check. No prompts, no requests.
  Future<bool> isEnabled() async {
    if (Platform.isIOS) {
      final s = await FirebaseMessaging.instance.getNotificationSettings();
      return s.authorizationStatus == AuthorizationStatus.authorized ||
          s.authorizationStatus == AuthorizationStatus.provisional;
    }

    if (Platform.isAndroid) {
      final android = _fln
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      // On <33 this will generally be true; on 33+ it reflects the app’s notif toggle.
      return await android?.areNotificationsEnabled() ?? true;
    }

    return true; // web/other
  }

  /// Check; if disabled, show an alert offering to open Settings.
  /// Returns the final "enabled" state (unchanged if the user cancels).
  Future<bool> ensureEnabledOrPrompt(BuildContext context) async {
    final ok = await isEnabled();
    if (ok) return true;

    if (!context.mounted) return false;

    final go =
        await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('الاشعارات'),
            content: const Text(
              'يرجى تفعيل الإشعارات  في الإعدادات لتلقي الاذكار.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('ليس الان'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('افتح الإعدادات'),
              ),
            ],
          ),
        ) ??
        false;

    if (go) {
      await openAppSettings(); // permission_handler
      // Optional: re-check after returning from Settings.
      return await isEnabled();
    }

    return false;
  }
}
