import 'dart:convert';

import 'package:tsbeh/helper/connection/cash/CashLocal.dart';
import 'package:tsbeh/models/zekerModel.dart';

import 'SleepHourClass.dart';
import 'ZekerTime.dart';

enum zekerListFor { selected, createdChanel }

class BuildAzkar {
  late ZekerTime everyTime;
  late SleepHourClass sleepTime;

  BuildAzkar() {
    everyTime = getEveryTime();
    sleepTime = SleepHourClass.get();
  }
  String stopTimeFormate() {
    if (sleepTime.stopAt == true) {
      String timeStart = timeFormate(
          sleepTime.startTime[0],
          sleepTime.startTime[
              1]); // "${sleepTime.startTime[0]}:${sleepTime.startTime[1]}";
      String timeEnd = timeFormate(
          sleepTime.endTime[0],
          sleepTime.endTime[
              1]); // "${sleepTime.endTime[0]}:${sleepTime.endTime[1]}";

      return "من ${timeStart} الى ${timeEnd}";
    }
    return "";
  }

  String timeFormate(int hour, int minutes) {
    String am = "ص";
    int newHour = hour;
    if (hour > 12) {
      am = "م";
      newHour = newHour - 12;
    }

    return "${newHour}:${minutes} $am";
  }

  static void play() {
    // PreferenceUtils.instance.setBool("ZekerPlay", true);
    CashLocal.saveCash("ZekerPlay", "true");
  }

  static void stop() {
    // PreferenceUtils.instance.setBool("ZekerPlay", false);
    CashLocal.saveCash("ZekerPlay", "false");
  }

  static bool isPlay() {
    // return PreferenceUtils.instance.getBool("ZekerPlay") ?? false;
    return CashLocal.getStringCash("ZekerPlay") == "true" ? true : false;
  }

  void saveEveryTime() async {
    String jsonStr = jsonEncode(everyTime);

    CashLocal.saveCash("ZekerTime", jsonStr);
    // PreferenceUtils.instance.setString("ZekerTime", jsonStr);
  }

  static ZekerTime getEveryTime() {
    // String jsonCls = PreferenceUtils.instance.getString("ZekerTime") ?? "";
    String jsonCls = CashLocal.getStringCash("ZekerTime");

    if (jsonCls.isNotEmpty) {
      Map<String, dynamic> map = json.decode(jsonCls);

      return ZekerTime.fromJson(map);
    }
    return ZekerTime();
  }

  static saveZekerListFor(List<ZekerModel> lst, zekerListFor key) {
    String jsonStr = jsonEncode(lst);

    CashLocal.saveCash(key.toString(), jsonStr);
    // PreferenceUtils.instance.setString(key.toString(), jsonStr);
  }

  static List<ZekerModel> getZekerListFor(zekerListFor key) {
    // String jsonCls = PreferenceUtils.instance.getString(key.toString()) ?? "";

    String jsonCls = CashLocal.getStringCash(key.toString());
    if (jsonCls.isNotEmpty) {
      List lst = json.decode(jsonCls);

      return ZekerModel.fromList(lst);
    }
    return [];
  }
}
