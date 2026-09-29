import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/connection/cash/CashLocal.dart';
import 'ThemeAppStates.dart';

class ThemeAppCubit extends Cubit<ThemeAppStates> {
  ThemeAppCubit() : super(InitialThemeAppState());
  static ThemeAppCubit get(context) => BlocProvider.of(context);

  bool IsDark = false;
  Locale _appLocale = Locale('en');

  Locale get appLocal => _appLocale; //?? Locale("en");

  static Future<String> getLang() async {
    var prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString('language_code');
    if (lang == null) {
      return 'en';
    } else {
      return lang;
    }
  }

  fetchLocale() async {
    String lang = await ThemeAppCubit.getLang();
    _appLocale = Locale(lang);
    // var prefs = await SharedPreferences.getInstance();
    // if (prefs.getString('language_code') == null) {
    //   _appLocale = Locale('en');
    //   return Null;
    // }
    // _appLocale = Locale(prefs.getString('language_code') as String);
    // return Null;
  }

  void ChangeAppMode({bool? fromShared, String? lang}) {
    if (lang != null) {
      _appLocale = Locale(lang);
    }

    if (fromShared != null) {
      IsDark = fromShared;

      emit(AppChangeModeState());
    } else {
      IsDark = !IsDark;

      CashLocal.saveCash("IsDark", IsDark.toString());
      emit(AppChangeModeState());
    }
  }

  void changeStartLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? langCode = prefs.getString('language_code');
    print(langCode);
    if (langCode != null) {
      // emit(Locale(langCode, ''));
      emit(AppChangeLangState());
    }
  }

  void changeLang(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', lang);
    // emit(Locale(data, ''));
    _appLocale = Locale(lang);

    emit(AppChangeLangState());
  }

  // void changeLangauge() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? langCode = prefs.getString('lang');
  //   if (langCode == 'ar') {
  //     changeLang('en');
  //   } else {
  //     changeLang('ar');
  //   }
  // }
}
