import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class appLocalizations {
  final Locale locale;

  static const LocalizationsDelegate<appLocalizations> delegate =
      _appLocalizationsDelegate();

  appLocalizations(this.locale);

  static appLocalizations? of(BuildContext context) {
    return Localizations.of<appLocalizations>(context, appLocalizations);
  }

  static Map<String, String> _localizedStrings = {};

  Future<bool> load() async {
    // Load the language JSON file from the "lang" folder
    String jsonString =
        await rootBundle.loadString('res/lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  static Future<bool> loadLocal(Locale locale) async {
    // Load the language JSON file from the "lang" folder
    String jsonString =
        await rootBundle.loadString('res/lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String translate(String key) {
    String? str = _localizedStrings[key];
    if (str == null) {
      return key;
    }
    if (str.isEmpty) {
      return key;
    }
    return str;
  }
}

class _appLocalizationsDelegate
    extends LocalizationsDelegate<appLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _appLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return ['en', 'ar', 'fr', 'af', 'de', 'es', 'id', 'pt', 'tr', 'hi']
        .contains(locale.languageCode);
  }

  @override
  Future<appLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    appLocalizations localizations = new appLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_appLocalizationsDelegate old) => true;
}

String keyString(BuildContext context, String key) {
  return appLocalizations.of(context)!.translate(key);
}
