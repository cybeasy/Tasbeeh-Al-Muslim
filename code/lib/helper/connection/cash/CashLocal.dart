import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'model/local_data.dart';

class CashLocal {

  static late final SharedPreferences instance;

  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();

  // static CashLocal get instance {
  //   // if (_instance == null) {
  //   _instance = CashLocal._init();
  //   // }
  //   return _instance!;
  // }

  // static CashLocal? _instance;
  // CashLocal._init();

  // late SharedPreferences _preferences;
  // Future<SharedPreferences> get preferences async {
  //   // if (_preferences == null) {
  //   _preferences = await SharedPreferences.getInstance();
  //   // }
  //   return _preferences;
  // }

   static void  writeModelInJson(dynamic body, String url,
      {Duration duration = const Duration(hours: 0)})   {
    final _pref = CashLocal.instance;

    BaseLocal local =
        BaseLocal(model: body, time: DateTime.now().add(duration));
    final json = jsonEncode(local.toJson());
    if (body != null && json.isNotEmpty) {
        _pref.setString(url, json);
    }
    
  }

 static String getModelString(String url)   {
    final _pref =  CashLocal.instance;
    String? jsonString = _pref.getString(url);
    if (jsonString != null) {
      try {
        final jsonModel = jsonDecode(jsonString);
        // final model = BaseLocal.fromJson(jsonModel);
        // if (DateTime.now().isAfter(model.time!)) {
        //   return BaseLocal.fromJson(jsonModel).model ?? "";
        // } else {
        //   await removeModel(url);
        // }
        return BaseLocal.fromJson(jsonModel).model ?? "";
      } catch (e) {}
    }

    return "";
  }

 static  bool removeAllLocalData(String url)   {
    final _pref = CashLocal.instance;
    _pref.getKeys().removeWhere((element) => element.contains(url));
    return true;
  }

 static Future<bool> removeModel(String url) async {
    final _pref = CashLocal.instance;
    return await _pref.remove(url);
  }

  // ================ ================ ================ ================ ================

  static  String  getStringCash(String key)   {
    // var perf = CashLocal.instance;
     
  return  CashLocal.getModelString(key);

    // return CashLocal.instance.getString(key) ?? "";
  }

  static  void removeCacheContains(String key)  {
    // var perf = CashLocal.instance;

    CashLocal.removeAllLocalData(key);

      // CashLocal.instance.getKeys().removeWhere((element) => element.contains(key));
  }

  static void removeCache(String key)   {
    // var perf = CashLocal.instance;
    // return await perf.removeModel(key);
    CashLocal.removeModel(key) ;
   }

  static void saveCash(String key, Object model,
      {Duration duration = const Duration(hours: 0)})   {
 

        CashLocal.writeModelInJson(model, key, duration: duration);

  
  }
}
