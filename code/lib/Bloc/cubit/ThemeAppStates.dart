import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ThemeAppStates {
  const ThemeAppStates();
}

class InitialThemeAppState extends ThemeAppStates {}

class AppChangeModeState extends ThemeAppStates {}

class AppChangeLangState extends ThemeAppStates {}
