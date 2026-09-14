import 'package:flutter/services.dart';
import 'package:tsbeh/models/zekerModel.dart';

class IosNativeCall {
  static const platform = MethodChannel('klib.flutter.dev/native');

  static Future<String> getFilePath(String fileName) async {
    return await platform.invokeMethod('getFilePath', {'fileName': fileName});
  }

  static Future<void> schedulingLocalNotificationInHour(String notficationId,
      String title, String sound, double minute, String payload) async {
    await platform.invokeMethod('schedulingLocalNotificationInHour', {
      "notficationId": notficationId,
      'title': title,
      "sound": sound,
      "minute": minute,
      "payload": payload
    });
  }

  static Future<void> cancelAllLocalNotification() async {
    await platform.invokeMethod('cancelAllLocalNotification');
  }

  static Future<void> cancelLocalNotification(String notficationId) async {
    await platform.invokeMethod('cancelLocalNotification', {
      "notficationId": notficationId,
    });
  }

  static Future<List<ZekerModel>> getPenddingLocalNotification() async {
    List<dynamic> list =
        await platform.invokeMethod('getPenddingLocalNotification');

    List<ZekerModel> listNotification = [];
    list.forEach((element) {
      Map<String, dynamic> map = ZekerModel.toMapString(element);
      listNotification.add(ZekerModel.fromJson(map));
    });

    return listNotification;
  }
}
