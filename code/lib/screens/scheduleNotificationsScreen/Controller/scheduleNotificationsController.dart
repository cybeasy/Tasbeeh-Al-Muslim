import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:tsbeh/AppRoutes.dart';
import 'package:tsbeh/models/IosNativeCall.dart';
import 'package:tsbeh/services/WebAzkarTimerService.dart';

import 'package:tsbeh/Bloc/AppCubit.dart';
import '../../../Notifications/Local/NotificationService.dart';
import 'package:tsbeh/main.dart';
import '../../../models/ZekerBuildNotifications/BuildAzkar.dart';
import '../../../models/zekerModel.dart';
import 'package:timezone/timezone.dart' as tz;

class scheduleNotificationsController {
  final Function() refresh;

  scheduleNotificationsController(this.refresh);

  List<ZekerModel> pendingList = [];
  List<tz.TZDateTime> timeList = [];

  late AppCubit cubit;

  BuildAzkar builder = BuildAzkar();

  bool isNotificationLessthan25Ios = false;

  bool loading = true;
  bool editSort = false;

  void update() {
    refresh();
  }

  Future<void> onInit() async {
    if (kIsWeb) {
      try {
        List<ZekerModel> list =
            BuildAzkar.getZekerListFor(zekerListFor.createdChanel);
        if (list.isEmpty) {
          list = BuildAzkar.getZekerListFor(zekerListFor.selected);
        }
        pendingList.clear();
        timeList.clear();
        for (var element in list) {
          pendingList.add(element);
          if (element.notficationScheduledDate != null) {
            timeList.add(element.notficationScheduledDate!);
          }
        }
      } catch (e) {
        debugPrint("Error loading web azkar list: $e");
      } finally {
        loading = false;
        update();
      }
      return;
    }

    if (!kIsWeb && Platform.isIOS &&
        builder.everyTime.hours == 0 &&
        builder.everyTime.minutes < 25) {
      isNotificationLessthan25Ios = true;
      IosNativeCall.getPenddingLocalNotification().then((list) {
        list.forEach((element) {
          pendingList.add(element);
          if (element.notficationScheduledDate != null) {
            timeList.add(element.notficationScheduledDate!);
          }
        });

        // pendingList.sortedBy((it) => it.notficationId!);
        loading = false;
        update();
      });
    } else {
      NotificationService().pending().then((list) {
        list.forEach((element) {
          pendingList.add(getNotificationModel(element));
          ZekerModel zeker =
              ZekerModel.fromJson(ZekerModel.toMapString(element.payload!));
          timeList.add(zeker.notficationScheduledDate!);
        });

        // pendingList.sortedBy((it) => it.notficationId!);
        loading = false;
        update();
      }).catchError((e) {
        debugPrint("Notification pending error: $e");
        loading = false;
        update();
      });
    }

    update();
  }

  ZekerModel getNotificationModel(
      PendingNotificationRequest notificationRequest) {
    return ZekerModel.fromJson(
        ZekerModel.toMapString(notificationRequest.payload!));
  }

  void deleteNotification(ZekerModel notificationRequest) {
    if (kIsWeb) {
      pendingList.removeWhere(
          (it) => it.notficationId == notificationRequest.notficationId);
      BuildAzkar.saveZekerListFor(pendingList, zekerListFor.createdChanel);
      update();
      return;
    }

    if (isNotificationLessthan25Ios) {
      IosNativeCall.cancelLocalNotification(
          notificationRequest.notficationId!.toString());
    } else {
      NotificationService()
          .cancelNotification(notificationRequest.notficationId!);
    }
  }

  Future<void> stop({BuildContext? context}) async {
    loading = true;
    refresh();
    try {
      BuildAzkar.stop();
      if (kIsWeb) {
        WebAzkarTimerService.instance.stop();
      } else {
        await NotificationService().cancelAll();
      }

      try {
        cubit.resetToInitial();
      } catch (_) {}

      loading = false;
      refresh();
      EasyLoading.showSuccess("تم إيقاف الأذكار بنجاح");

      await Future.delayed(const Duration(milliseconds: 600));

      if (context != null && context.mounted) {
        AppRoutes.back(context: context);
      } else {
        AppRoutes.openHomeScreen();
      }
    } catch (e) {
      debugPrint("Error stopping azkar: $e");
      loading = false;
      refresh();
      EasyLoading.showError("حدث خطأ أثناء إيقاف الأذكار");
    }
  }

  void playSound(ZekerModel temp) async {
    if (kIsWeb) {
      await WebAzkarTimerService.instance.playSingleZeker(temp);
      return;
    }

    String path = temp.soundFileNamePath();
    if (Platform.isAndroid) {
      Uri fileUrl = Uri.parse(path);
      var audio = AudioSource.uri(
        fileUrl,
        tag: MediaItem(
          id: "1",
          title: "    ${temp.zeker_name}   ",
        ),
      );

      player.setAudioSource(audio).then((value) {
        player.play();
      }).catchError((e) {
        print("Audio play error: $e");
      });
    } else {
      String fileUrl = await ZekerModel.getPassFileInIOS(path);

      var audio = AudioSource.file(
        fileUrl,
        tag: MediaItem(
          id: "1",
          title: temp.zeker_name,
        ),
      );
      player.setAudioSource(audio).then((value) {
        player.play();
      }).catchError((e) {
        print("Audio play error: $e");
      });
    }
  }

  // Sort
  void updateSortTime() {
    for (int index = 0; index < pendingList.length; index++) {
      ZekerModel zekerModel = pendingList[index];
      if (index < timeList.length) {
        zekerModel.notficationScheduledDate = timeList[index];
      }
    }

    update();
  }

  Future<void> saveSort() async {
    EasyLoading.show();
    editSort = false;
    if (kIsWeb) {
      BuildAzkar.saveZekerListFor(pendingList, zekerListFor.createdChanel);
      EasyLoading.dismiss();
      update();
      return;
    }

    await NotificationService().cancelAll();
    for (final element in pendingList) {
      await NotificationService().scheduleLocalNotifications(element);
    }
    EasyLoading.dismiss();
    update();
  }
}
