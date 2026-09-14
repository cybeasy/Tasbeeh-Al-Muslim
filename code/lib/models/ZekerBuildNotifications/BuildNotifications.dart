import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tsbeh/helper/List+ext.dart';
import 'package:tsbeh/models/IosNativeCall.dart';
import 'package:tsbeh/models/zekerModel.dart';
import 'package:tsbeh/services/WebAzkarTimerService.dart';

import '../../Notifications/Local/NotificationService.dart';
import '../../main.dart';
import 'BuildAzkar.dart';

import 'SleepHourClass.dart';
import 'ZekerTime.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:intl/intl.dart';

class BuildNotifications {
  late List<ZekerModel> zekerList;
  int fileCursor = 0;

  Future<void> stop(BuildContext context) async {
    if (kIsWeb) {
      WebAzkarTimerService.instance.stop();
      return;
    }
    await removeAllChanel();
  }

  void testPush({ZekerModel? zekerModel}) {
    NotificationService().cancelAll();
    tz.TZDateTime scheduledDate = tz.TZDateTime.now(tz.local);

    scheduledDate = scheduledDate.add(const Duration(minutes: 1));

    zekerModel = ZekerModel();
    zekerModel.zeker_id = "1";
    zekerModel.zeker_repeat = 1;
    zekerModel.channelID = "a1_1";
    zekerModel.channelName = "a1_1";
    zekerModel.channelDescription = "";
    zekerModel.notficationId = 1;
    zekerModel.fullFileName = "a1_1";
    zekerModel.notficationTitle = "test";
    zekerModel.notficationBody = "test";
    zekerModel.notficationScheduledDate = scheduledDate;
    zekerModel.zeker_type = "";
    zekerModel.zeker_name = "test";
    zekerModel.zeker_time = 0;
    zekerModel.zeker_order = 0;

    // "a1_1"
    NotificationService().scheduleLocalNotifications(zekerModel);
    log("test push ${zekerModel.soundFileName()}  ");
  }

  Future<void> build(
      BuildAzkar bz, BuildContext context, Function(int, int) generated) async {
    if (kIsWeb) {
      zekerList = BuildAzkar.getZekerListFor(zekerListFor.selected);
      if (zekerList.isEmpty) return;

      fileCursor = 0;
      int countarr = zekerList.length;
      List<ZekerTime> zTimeList = getListZekerTime(bz);
      SleepHourClass sleepHours = SleepHourClass.get();
      List<ZekerModel> scheduledList = [];

      for (int i = 0; i < zTimeList.length; i++) {
        ZekerTime zekerTime = zTimeList[i];
        if (excludeTime(zekerTime, sleepHours, bz) == false) {
          ZekerModel zekerModel = getZekerSelected(countarr);
          zekerModel.channelID = zekerModel.soundFileName();
          zekerModel.channelName = zekerModel.zeker_name;
          zekerModel.channelDescription = "";
          zekerModel.notficationId = zekerTime.timeID();
          zekerModel.notficationTitle = zekerModel.zeker_name;
          zekerModel.notficationScheduledDate = zekerTime.scheduledDate();
          zekerModel.notficationScheduledMinute = zekerTime.minutes;
          scheduledList.add(zekerModel);
        }
        generated(i, zTimeList.length);
        await Future.delayed(const Duration(milliseconds: 5));
      }

      BuildAzkar.saveZekerListFor(scheduledList, zekerListFor.createdChanel);
      WebAzkarTimerService.instance.start();
      return;
    }
    await removeAllChanel();

    // testPush();
    // return;

    zekerList = BuildAzkar.getZekerListFor(zekerListFor.selected);

    BuildAzkar.saveZekerListFor(zekerList, zekerListFor.createdChanel);

    await removeAllChanel();
    await buildList(bz, generated);
  }

  tz.TZDateTime getDate() {
    var currentDate = DateFormat(dateFormat).format(DateTime.now());

    final DateTime tempDate = DateFormat(dateFormat).parse(currentDate);

    tz.TZDateTime scheduledDate = tz.TZDateTime.from(tempDate, tz.local);

    return scheduledDate;
  }

  Future<void> removeAllChanel() async {
    if (kIsWeb) return;
    await NotificationService().cancelAll();
  }

  List<ZekerTime> getListZekerTime(BuildAzkar bz) {
    List<ZekerTime> zTimeList = [];
    int Fn = 1;
    bool stop = false;
    int totalMinutes = bz.everyTime.hours * 60 + bz.everyTime.minutes;
    do {
      ZekerTime x = ZekerTime();

      int newTotalMinutes = totalMinutes * Fn;

      double h = newTotalMinutes / 60;
      double m = newTotalMinutes % 60;

      x.minutes = m.toInt();
      x.hours = x.hours + h.toInt();

      Fn++;

      if (x.hours >= 24) {
        x.hours = 0;
        if (x.hours == 0 && x.minutes == 0) {
          zTimeList.insert(0, x);
        } else {
          zTimeList.add(x);
        }
        print("N$Fn = ${x.hours}:${x.minutes}");

        stop = true;
      }
      if (stop == false) {
        zTimeList.add(x);
        print("N$Fn = ${x.hours}:${x.minutes}");
      }
    } while (!stop);
    return zTimeList;
  }

  ZekerModel getZekerSelected(int countarr) {
    ZekerModel temp = zekerList[fileCursor];
    fileCursor = fileCursor + 1;
    if (fileCursor > countarr - 1) {
      fileCursor = 0;
    }

    String zekerId = "${temp.zeker_id}";
    if (temp.choose_repeat.isEmpty == false && temp.zeker_repeat != 1) {
      int chooseRepeat = int.parse(temp.choose_repeat);
      int filerepeat = temp.zeker_repeat;

      if (filerepeat < chooseRepeat) {
        chooseRepeat = filerepeat;
      }

      temp.fullFileName = "a$zekerId" "_" "$chooseRepeat";
    } else {
      temp.fullFileName = "a$zekerId";
    }

    return temp;
  }

  Future<void> buildList(BuildAzkar bz, Function(int, int) generated) async {
    if (!kIsWeb && Platform.isIOS &&
        bz.everyTime.hours == 0 &&
        bz.everyTime.minutes < 25) {
      await buildListIosTime25(bz);
    } else {
      await buildListAndroidIos(bz, generated);
    }
  }

  // build List If Time Less Than 25 Minutes in ios only
  Future<void> buildListIosTime25(BuildAzkar bz) async {
    fileCursor = 0;
    int countarr = zekerList.length;
    int minutesToRepeat = bz.everyTime.minutes;
    List<ZekerTime> zTimeList = [];
    double countRepeat = 60 / minutesToRepeat;
    for (int i = 1; i <= countRepeat; i++) {
      ZekerTime x = ZekerTime();
      x.hours = 0;
      x.minutes = minutesToRepeat * i;
      if (x.minutes == 60) {
        x.minutes = 0;
      }
      zTimeList.add(x);
    }

    for (int i = 0; i < zTimeList.length; i++) {
      ZekerTime zekerTime = zTimeList[i];

      ZekerModel zekerModel = getZekerSelected(countarr);
      log("${zekerModel.soundFileName()} / ${zekerTime.toJson()}");

      zekerModel.channelID = zekerModel.soundFileName();
      zekerModel.channelName = zekerModel.zeker_name;
      zekerModel.channelDescription = "";
      zekerModel.notficationId = zekerTime.timeID();
      zekerModel.notficationTitle = zekerModel.zeker_name;
      zekerModel.notficationScheduledMinute = zekerTime.minutes;

      await IosNativeCall.schedulingLocalNotificationInHour(
          zekerModel.notficationId.toString(),
          zekerModel.zeker_name,
          zekerModel.soundFileName(),
          zekerTime.minutes.toDouble(),
          zekerModel.toStringJson());
    }
    // int count = await NotificationService().count();
    // log("Stored Notifications : $count ");
  }

  // build List If Time greater Than 25 Minutes in ios and android
  Future<void> buildListAndroidIos(
      BuildAzkar bz, Function(int, int) generated) async {
    fileCursor = 0;
    int countarr = zekerList.length;

    List<ZekerTime> zTimeList = getListZekerTime(bz);
    SleepHourClass sleepHours = SleepHourClass.get();

    for (int i = 0; i < zTimeList.length; i++) {
      ZekerTime zekerTime = zTimeList[i];
      await Future.delayed(Duration(milliseconds: 10));

      if (excludeTime(zekerTime, sleepHours, bz) == false) {
        ZekerModel zekerModel = getZekerSelected(countarr);
        log("${zekerModel.soundFileName()} / ${zekerTime.toJson()}");

        zekerModel.channelID = zekerModel.soundFileName();
        zekerModel.channelName = zekerModel.zeker_name;
        zekerModel.channelDescription = "";
        zekerModel.notficationId = zekerTime.timeID();
        zekerModel.notficationTitle = zekerModel.zeker_name;
        zekerModel.notficationScheduledDate = zekerTime.scheduledDate();

        // For Test run push after 1 minute
        // if (i == 0) {
        //   testPush(zekerModel: zekerModel);
        // }
        generated(i, zTimeList.length);

        NotificationService().scheduleLocalNotifications(zekerModel);
      }
    }
    // int count = await NotificationService().count();
    // log("Stored Notifications : $count ");
  }

  static bool excludeTime(
      ZekerTime zekerTime, SleepHourClass sleepHours, BuildAzkar bz) {
    if (bz.sleepTime.stopAt == false) {
      return false;
    }

    bool exclude = false;

    int zekerTimeInMinutes = zekerTime.hours * 60 + zekerTime.minutes;

    int startSleepHourinMinutes =
        sleepHours.startTime[0] * 60 + sleepHours.startTime[1];
    int endSleepHourinMinutes =
        sleepHours.endTime[0] * 60 + sleepHours.endTime[1];

    if (startSleepHourinMinutes > endSleepHourinMinutes) // it's in two day
    {
      // start time compare to  1440 (24*60)
      if (zekerTimeInMinutes >= startSleepHourinMinutes &&
          zekerTimeInMinutes <= 1440) {
        exclude = true;
      } else if (zekerTimeInMinutes >= 0 &&
          zekerTimeInMinutes <= endSleepHourinMinutes) {
        exclude = true;
      }
    } else {
      // in same day
      if (zekerTimeInMinutes >= startSleepHourinMinutes &&
          zekerTimeInMinutes <= endSleepHourinMinutes) {
        exclude = true;
      }
    }

    if (exclude) {
      log("excludeTime : ${zekerTime.toJson()} ");
    }

    return exclude;
  }
}
