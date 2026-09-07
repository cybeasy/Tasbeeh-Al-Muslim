import 'dart:io';
import 'dart:math';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:tsbeh/AppRoutes.dart';
import 'package:tsbeh/helper/List+ext.dart';
import 'package:tsbeh/models/IosNativeCall.dart';

import '../../../Bloc/AppCubit.dart';
import '../../../Bloc/AppStates.dart';
import '../../../Notifications/Local/NotificationService.dart';
import '../../../main.dart';
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
    if (Platform.isIOS &&
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
    if (isNotificationLessthan25Ios) {
      IosNativeCall.cancelLocalNotification(
          notificationRequest.notficationId!.toString());
    } else {
      NotificationService()
          .cancelNotification(notificationRequest.notficationId!);
    }
  }

  void stop() {
    loading = true;
    refresh();
    BuildAzkar.stop();
    NotificationService().cancelAll().then((value) {
      cubit.resetToInitial();
      loading = false;

      AppRoutes.back();
    });
  }

  void playSound(ZekerModel temp) async {
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
      });
    }
  }

  // Sort
  void updateSortTime() {
    for (int index = 0; index < pendingList.length; index++) {
      ZekerModel zekerModel = pendingList[index];
      zekerModel.notficationScheduledDate = timeList[index];
    }

    update();
  }

  Future<void> saveSort() async {
    EasyLoading.show();
    editSort = false;
    NotificationService().cancelAll();
    pendingList.forEach((element) async {
      await NotificationService().scheduleLocalNotifications(element);
    });
    EasyLoading.dismiss();
    update();
  }
}
