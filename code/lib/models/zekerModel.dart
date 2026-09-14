import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:tsbeh/helper/dbSQLiteProvider.dart';
import 'package:tsbeh/models/IosNativeCall.dart';

class ZekerModel {
  ZekerModel();

  late String zeker_id;
  late int zeker_type_id;
  late String zeker_type;
  late String zeker_name;
  late int zeker_repeat;
  late int zeker_time;
  late int zeker_order;

  late bool selected = false;
  late String choose_repeat = "1";

  String? fullFileName;

// Notfication option
  String? channelID;
  String? channelName;
  String? channelDescription;
  int? notficationId;
  String? notficationTitle;
  String? notficationBody;
  tz.TZDateTime? notficationScheduledDate;
  int? notficationScheduledMinute;

  String soundFileName() {
    if (kIsWeb) {
      return "${fullFileName}.mp3";
    }
    if (Platform.isAndroid) {
      return fullFileName!;
    } else if (Platform.isIOS) {
      return "${fullFileName}.mp3";
    } else {
      return fullFileName!;
    }
  }

  String soundFileNamePath() {
    String file = zeker_id;
    if (choose_repeat.isEmpty == false && zeker_repeat != 1) {
      int chooseRepeat = int.parse(choose_repeat);
      int filerepeat = zeker_repeat;

      if (filerepeat < chooseRepeat) {
        chooseRepeat = filerepeat;
      }

      file = "$file" "_" "$chooseRepeat";
    }

    file = "a$file";
    if (kIsWeb) {
      return "assets/sounds/${file}.mp3";
    }
    if (Platform.isAndroid) {
      return "android.resource://com.tsbeh/raw/$file";
    } else if (Platform.isIOS) {
      // return "assets/raw/${file}.mp3";

      return "${file}.mp3";
    } else {
      return "assets/sounds/${file}.mp3";
    }
  }

  static Future<String> getPassFileInIOS(String fileName) async {
    return await IosNativeCall.getFilePath(fileName);
  }

  static Future<List<ZekerModel>> getListOfRepeats(BuildContext context) async {
    return getList(context, 1);
  }

  static Future<List<ZekerModel>> getListOfazkar(BuildContext context) async {
    return getList(context, 2);
  }

  static Future<List<ZekerModel>> getListOfDoaa(BuildContext context) async {
    return getList(context, 3);
  }

  static Future<List<ZekerModel>> getListOfQuran(BuildContext context) async {
    return getList(context, 4);
  }

  static Future<List<ZekerModel>> getList(
      BuildContext context, int type_id) async {
    // String data = await DefaultAssetBundle.of(context)
    //     .loadString("assets/json/$fileName.json");
    // final jsonResult = jsonDecode(data);

    // return ZekerModel.fromList(jsonResult);

    String sql = """
         SELECT * FROM zeker where zeker_type_id = $type_id
     """;
    final db = await dbSQLiteProvider.db.database;

    List<Map> results = await db.rawQuery(sql);

    List<ZekerModel> lst = ZekerModel.fromList(results); //new List();
    // results.forEach((result) {
    //   ZekerModel obj = readJson(result);

    //   lst.add(obj);
    // });
    return lst;
  }

  static List<ZekerModel> fromList(List data) {
    List<ZekerModel> arr = [];

    for (int i = 0; i < data.length; i++) {
      ZekerModel temp = ZekerModel.fromJson(data[i]);
      arr.add(temp);
    }

    return arr;
  }

  factory ZekerModel.fromJson(Map<String, dynamic> map) {
    var cls = ZekerModel();
    cls.zeker_id = map["zeker_id"]!;
    cls.zeker_type = map["zeker_type"]!;
    cls.zeker_name = map["zeker_name"]!;
    cls.zeker_repeat = map["zeker_repeat"] ?? 1;
    cls.zeker_time = map["zeker_time"]!;
    cls.zeker_order = map["zeker_order"] ?? 1000;
    cls.choose_repeat = map["choose_repeat"] ?? "1";
    cls.selected = map["selected"] ?? false;

    cls.fullFileName = map["fullFileName"] ?? "";
    cls.channelID = map["channelID"] ?? "";
    cls.channelName = map["channelName"] ?? "";
    cls.channelDescription = map["channelDescription"] ?? "";
    cls.notficationId = map["notficationId"] ?? 0;
    cls.notficationTitle = map["notficationTitle"] ?? "";
    cls.notficationBody = map["notficationBody"] ?? "";
    cls.notficationScheduledMinute = map["notficationScheduledMinute"] ?? 0;

    String dt = map["notficationScheduledDate"] ?? "";
    if (dt.isNotEmpty) {
      cls.notficationScheduledDate =
          tzDateTimeFromString(value: dt, isUtc: false)!;
    }
    return cls;
  }

  Map<String, dynamic> toJson() => {
        'zeker_id': zeker_id,
        'zeker_type': zeker_type,
        'zeker_name': zeker_name,
        'zeker_repeat': zeker_repeat,
        'zeker_time': zeker_time,
        'zeker_order': zeker_order,
        'choose_repeat': choose_repeat,
        'selected': selected,
        'fullFileName': fullFileName,
        'channelID': channelID,
        'channelName': channelName,
        'channelDescription': channelDescription,
        'notficationId': notficationId,
        'notficationTitle': notficationTitle,
        'notficationBody': notficationBody,
        'notficationScheduledMinute': notficationScheduledMinute,
        'notficationScheduledDate': notficationScheduledDate == null
            ? ""
            : tzDateTimeToString(dt: notficationScheduledDate!),
      };

  String toStringJson() {
    return json.encode(toJson());
  }

  static Map<String, dynamic> toMapString(String str) {
    return json.decode(str);
  }

  String scheduledDate() {
    return tzDateTimeToString(
        dt: notficationScheduledDate!, currentFormat: "hh:mm a");
  }

  static String tzDateTimeToString(
      {required tz.TZDateTime dt,
      String currentFormat = "yyyy-MM-dd HH:mm:ss"}) {
    String formattedDate = DateFormat(currentFormat).format(dt);

    return formattedDate;
  }

  static tz.TZDateTime? tzDateTimeFromString(
      {required String value,
      String currentFormat = "yyyy-MM-dd HH:mm:ss",
      String desiredFormat = "yyyy-MM-dd HH:mm:ss",
      isUtc = true}) {
    DateTime? dateTime;
    if (value.isNotEmpty) {
      try {
        dateTime = DateFormat(currentFormat).parse(value, isUtc).toLocal();
      } catch (e) {
        print("$e");
      }
    }
    if (dateTime != null) {
      tz.TZDateTime? dt = tz.TZDateTime.from(dateTime, tz.local);
      return dt;
    }

    return null;
  }
}
