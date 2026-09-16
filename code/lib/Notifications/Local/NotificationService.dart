import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../../models/zekerModel.dart';

/// https://www.freecodecamp.org/news/local-notifications-in-flutter/

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationService {
  // static final NotificationService _notificationService =
  //     NotificationService._internal();

  // factory NotificationService() {
  //   return _notificationService;
  // }

  // NotificationService._internal();

  // static const String CHANNEL_ID = "TSBEH";
  // static const String CHANNEL_NAME = "TSBEH";
  // static const String CHANNEL_DESCRIPTION = "";

  Future<void> createChannel(ZekerModel zekerModel) async {
    if (!Platform.isAndroid) return;

    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      zekerModel.channelID!,
      zekerModel.channelName!,
      description: zekerModel.channelDescription ?? '',
      importance: Importance.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(zekerModel.soundFileName()),
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  NotificationDetails notificationDetails(ZekerModel zekerModel) {
    return NotificationDetails(
      android: androidPlatformChannelSpecifics(zekerModel),
      iOS: iOSPlatformChannelSpecifics(zekerModel),
    );
  }

  AndroidNotificationDetails androidPlatformChannelSpecifics(
    ZekerModel zekerModel,
  ) {
    return AndroidNotificationDetails(
      zekerModel.channelID!,
      zekerModel.channelName!,
      channelDescription: zekerModel.channelDescription,
      sound: RawResourceAndroidNotificationSound(zekerModel.soundFileName()),
      importance: Importance.max,
      fullScreenIntent: true,
      priority: Priority.high,
      playSound: true,
    );
  }

  DarwinNotificationDetails iOSPlatformChannelSpecifics(ZekerModel zekerModel) {
    String soundName = zekerModel.soundFileName();
    return DarwinNotificationDetails(
      presentAlert:
          true, // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentBadge:
          true, // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentSound:
          true, // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      sound:
          soundName, // Specifics the file path to play (only from iOS 10 onwards)
      badgeNumber: 0, // The application's icon badge number
      // attachments: List<IOSNotificationAttachment>?, (only from iOS 10 onwards)
      // subtitle: String?, //Secondary description  (only from iOS 10 onwards)
      // threadIdentifier: String? (only from iOS 10 onwards)
    );
  }

  // NotificationDetails notificationDetails(String soundFileName) {
  //   return NotificationDetails(
  //     android: AndroidNotificationDetails(
  //       CHANNEL_ID,
  //       CHANNEL_NAME,
  //       channelDescription: CHANNEL_DESCRIPTION,
  //       sound: RawResourceAndroidNotificationSound(soundFileName),
  //       playSound: true,
  //     ),
  //     // iOS: IOSNotificationDetails(
  //     //   presentAlert:
  //     //       true, // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
  //     //   presentBadge:
  //     //       true, // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
  //     //   presentSound:
  //     //       true, // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
  //     //   sound:
  //     //       soundFileName, // Specifics the file path to play (only from iOS 10 onwards)
  //     //   badgeNumber: 1, // The application's icon badge number
  //     // )
  //   );
  // }

  // Future<void> init() async {

  //     await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();

  //   final AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('ic_logo');

  //   // final IOSInitializationSettings initializationSettingsIOS =
  //   //     IOSInitializationSettings(
  //   //   requestSoundPermission: true,
  //   //   requestBadgePermission: true,
  //   //   requestAlertPermission: true,
  //   //   onDidReceiveLocalNotification: onDidReceiveLocalNotification,
  //   // );

  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(
  //           android: initializationSettingsAndroid,
  //           // iOS: initializationSettingsIOS,
  //           macOS: null);

  //   tz.initializeTimeZones();

  //   // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //   //     onSelectNotification: selectNotification);
  // }

  static Future<void> init() async {
    try {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('ic_logo');

      final DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            // onDidReceiveLocalNotification: onDidReceiveLocalNotification
          );

      final InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
          );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveNotificationResponse,
      );
    } catch (e, st) {
      debugPrint("NotificationService.init error: $e\n$st");
    }
  }

  // static Future<void> askNotifPermissionIfNeeded() async {
  //   if (Platform.isIOS) {
  //     // For iOS:
  //     // await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
  //     final bool? result = await flutterLocalNotificationsPlugin
  //         .resolvePlatformSpecificImplementation<
  //           IOSFlutterLocalNotificationsPlugin
  //         >()
  //         ?.requestPermissions(alert: true, badge: true, sound: true);

  //     // Push notifications (Firebase Messaging) — required for APNS/FCM
  //     await FirebaseMessaging.instance.requestPermission(
  //       alert: true,
  //       badge: true,
  //       sound: true,
  //     );
  //   } else if (Platform.isAndroid) {
  //     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  //     final androidInfo = await deviceInfo.androidInfo;
  //     int sdk = androidInfo.version.sdkInt;
  //     if (sdk >= 34) {
  //       final bool? result2 = await flutterLocalNotificationsPlugin
  //           .resolvePlatformSpecificImplementation<
  //             AndroidFlutterLocalNotificationsPlugin
  //           >()
  //           ?.requestExactAlarmsPermission();
  //       print("requestNotificationsPermission: $result2");
  //     } else {
  //       final bool? result2 = await flutterLocalNotificationsPlugin
  //           .resolvePlatformSpecificImplementation<
  //             AndroidFlutterLocalNotificationsPlugin
  //           >()
  //           ?.requestNotificationsPermission();
  //       print("requestNotificationsPermission: $result2");
  //     }
  //   }
  // }

  static Future<void> askNotifPermissionIfNeeded() async {
    if (kIsWeb) return;
    try {
      if (Platform.isIOS) {
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true);

        // لطلب إذن إشعارات Push على iOS
        await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
        return;
      }

      // ANDROID
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final sdk = androidInfo.version.sdkInt;

        final android = flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

        // 1) إذن الإشعارات الأساسي (POST_NOTIFICATIONS) عند الحاجة (Android 13+)
        // يطلب أولاً ليظهر الـ Dialog للمستخدم في الواجهة فوراً وبشكل صريح
        if (sdk >= 33) {
          final enabled = await android?.areNotificationsEnabled() ?? true;
          if (!enabled) {
            await android?.requestNotificationsPermission();
          }
        }
      }
    } catch (e) {
      debugPrint("Error requesting notification permission: $e");
    }
  }

  static Future<void> askExactAlarmPermissionIfNeeded() async {
    if (kIsWeb || !Platform.isAndroid) return;
    try {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdk = androidInfo.version.sdkInt;
      if (sdk >= 31) {
        final android = flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        await android?.requestExactAlarmsPermission();
      }
    } catch (e) {
      debugPrint("Error requesting exact alarm permission: $e");
    }
  }

  @pragma('vm:entry-point')
  static void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');

      //    tz.TZDateTime scheduledDate = tz.TZDateTime.now(tz.local);

      // scheduledDate = scheduledDate.add(const Duration(minutes: 2));

      //   NotificationService().scheduleLocalNotifications(id: 1,title: "title",body: "title",scheduledDate: scheduledDate);
    }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }

  // Future<void> selectNotification(String? payload) async {
  //   //Handle notification tapped logic here
  // }
  @pragma('vm:entry-point')
  static Future<void> onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    //Handle notification tapped logic here
  }

  static Future<bool> canScheduleExact() async {
    if (kIsWeb || !Platform.isAndroid) return false;
    try {
      final android = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return await android?.canScheduleExactNotifications() ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> scheduleLocalNotifications(ZekerModel zekerModel) async {
    if (kIsWeb) return;
    try {
      await createChannel(zekerModel);

      AndroidScheduleMode scheduleMode = AndroidScheduleMode.exactAllowWhileIdle;
      if (Platform.isAndroid) {
        final canExact = await canScheduleExact();
        scheduleMode = canExact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle;
      }

      await flutterLocalNotificationsPlugin.zonedSchedule(
        zekerModel.notficationId!,
        zekerModel.notficationTitle,
        zekerModel.notficationBody,
        zekerModel.notficationScheduledDate!,
        notificationDetails(zekerModel),
        androidScheduleMode: scheduleMode,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: zekerModel.toStringJson(),
      );
    } catch (e) {
      debugPrint("Error scheduling notification ${zekerModel.notficationId}: $e");
    }
  }

  // Future<void> scheduleLocalNotificationsMinutes( int id,   String title,  String body, int minutes) async
  // {
  //   await scheduleLocalNotifications(id,title,body,tz.TZDateTime.now(tz.local).add( Duration(minutes: minutes))) ;
  // }

  Future<void> repeatLocalNotifications(
    int id,
    String title,
    String body,
    int durationHour,
  ) async {
    // const NotificationDetails platformChannelSpecifics =  notificationDetails ;// NotificationDetails(android: androidPlatformChannelSpecifics);
    // await flutterLocalNotificationsPlugin.periodicallyShow(0, title,
    //     body, RepeatInterval.everyMinute, platformChannelSpecifics,
    //     androidAllowWhileIdle: true);
  }

  // Future<void> scheduleLocalNotificationsMinutes( int id,   String title,  String body, int minutes) async
  // {
  //   await scheduleLocalNotifications(id,title,body,tz.TZDateTime.now(tz.local).add( Duration(minutes: minutes))) ;
  // }

  // Future<void> repeatLocalNotifications( int id,   String title,  String body, int durationHour) async
  // {
  //
  //   const NotificationDetails platformChannelSpecifics =  notificationDetails ;// NotificationDetails(android: androidPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.periodicallyShow(0, title,
  //       body, RepeatInterval.everyMinute, platformChannelSpecifics,
  //       androidAllowWhileIdle: true);
  // }

  Future<void> cancelNotification(int notificationID) async {
    await flutterLocalNotificationsPlugin.cancel(notificationID);
  }

  Future<void> cancelAll() async {
    if (kIsWeb) return;
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<int> count() async {
    List<PendingNotificationRequest> list =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return list.length;
  }

  Future<List<PendingNotificationRequest>> pending() async {
    List<PendingNotificationRequest> list =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return list;
  }
}
