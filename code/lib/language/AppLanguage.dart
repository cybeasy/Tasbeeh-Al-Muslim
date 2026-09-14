// import 'package:flutter/cupertino.dart';
// import 'package:nb_utils/nb_utils.dart';

// import 'appLocalizations.dart';

// class AppLanguage extends ChangeNotifier {
//   Locale _appLocale = Locale('en');

//   Locale get appLocal => _appLocale ;//?? Locale("en");

//   fetchLocale() async {
//     var prefs = await SharedPreferences.getInstance();
//     if (prefs.getString('language_code') == null) {
//       _appLocale = Locale('en');
//       return Null;
//     }
//     _appLocale = Locale(prefs.getString('language_code') as String);
//     return Null;
//   }

//   static Future<bool> is_frist_run() async {
//     var prefs = await SharedPreferences.getInstance();
//     if (prefs.getString('language_code') == null) {

//       return true;
//     }
//      return false;
//   }


//   static Future<String>  get_selected_lang() async {

//     var prefs = await SharedPreferences.getInstance();
//     var lang = prefs.getString('language_code');
//     if ( lang != null) {

//       return lang;
//     }

//     return "en" ;
//   }


//   void changeLanguage(Locale type) async {
//     var prefs = await SharedPreferences.getInstance();
//     // if (_appLocale == type) {
//     //   return;
//     // }
//     if (type == Locale("ar")) {
//       _appLocale = Locale("ar");
//       await prefs.setString('language_code', 'ar');
//       await prefs.setString('countryCode', '');
//     } else {
//       _appLocale = Locale("en");
//       await prefs.setString('language_code', 'en');
//       await prefs.setString('countryCode', '');
//     }

//     appLocalizations.loadLocal(_appLocale);

//     notifyListeners();
//   }
// }