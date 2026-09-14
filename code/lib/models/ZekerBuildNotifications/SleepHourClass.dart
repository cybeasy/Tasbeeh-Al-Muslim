import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:tsbeh/helper/connection/cash/CashLocal.dart';

class SleepHourClass {
  SleepHourClass();

  bool stopAt = false;

  var startTime = [21, 0];
  var endTime = [7, 0]; // TimeOfDay(hour: 7, minute: 0);

  SleepHourClass.fromJson(Map<String, dynamic> json)
      : startTime = json['startTime'].cast<int>(),
        endTime = json['endTime'].cast<int>(),
        stopAt = json['stopAt'];

  Map<String, dynamic> toJson() => {
        'startTime': startTime,
        'endTime': endTime,
        'stopAt': stopAt,
      };

  save() {
    String jsonStr = json.encode(toJson());
    CashLocal.saveCash("SleepHourClass", jsonStr);
    print("SleepHourClass :" + jsonStr);
  }

  static SleepHourClass get() {
    String jsonCls = CashLocal.getStringCash("SleepHourClass");
    if (jsonCls.isNotEmpty) {
      Map<String, dynamic> map = json.decode(jsonCls);
      print(map);
      SleepHourClass cls = SleepHourClass.fromJson(map);
      return cls;
    }
    return SleepHourClass();
  }

  String toStringFormated() {
    int startHour = startTime[0];
    String startp = "ص";
    if (startHour > 12) {
      startHour = startHour - 12;
      startp = "م";
    }

    int endHour = endTime[0];
    String endP = "ص";
    if (endHour > 12) {
      endHour = endHour - 12;
      endP = "م";
    }

    return " من " +
        "${startHour}:${startTime[1]} $startp" +
        " الى " +
        "${endHour}:${endTime[1]} $endP";
  }

  static Future<TimeRange?> showTimeRange(BuildContext context) async {
    SleepHourClass sleepH = await SleepHourClass.get();

    TimeRange? result = await showTimeRangePicker(
        context: context,
        start:
            TimeOfDay(hour: sleepH.startTime[0], minute: sleepH.startTime[1]),
        end: TimeOfDay(hour: sleepH.endTime[0], minute: sleepH.endTime[1]),
        // disabledTime: TimeRange(
        //     startTime: TimeOfDay(hour: 22, minute: 0),
        //     endTime: TimeOfDay(hour: 5, minute: 0)),
        disabledColor: Colors.red.withOpacity(0.5),
        strokeWidth: 4,
        ticks: 24,
        ticksOffset: -7,
        ticksLength: 15,
        ticksColor: Colors.grey,
        labels: [
          "12 am",
          "3 am",
          "6 am",
          "9 am",
          "12 pm",
          "3 pm",
          "6 pm",
          "9 pm"
        ].asMap().entries.map((e) {
          return ClockLabel.fromIndex(idx: e.key, length: 8, text: e.value);
        }).toList(),
        labelOffset: 35,
        rotateLabels: true,
        use24HourFormat: false,
        padding: 60);

    if (result != null) {
      SleepHourClass sleepH = new SleepHourClass();

      sleepH.startTime = [result.startTime.hour, result.startTime.minute];
      sleepH.endTime = [result.endTime.hour, result.endTime.minute];
      sleepH.stopAt = true;

      sleepH.save();

      // LocalNotifications(context).repeatWaterNotifications();
    }

    return result;
  }
}
