import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_schemes.dart';

ThemeData lightTheme = ThemeData(
    textTheme: GoogleFonts.cairoTextTheme(),
    useMaterial3: true,
    // brightness: Brightness.light,
    colorSchemeSeed: Color.fromARGB(255, 253, 93, 0),
    // colorScheme: lightColorScheme,
    iconTheme: IconThemeData(color: lightColorScheme.onPrimaryContainer));
ThemeData darkthemes = ThemeData(
    textTheme: GoogleFonts.cairoTextTheme(),

    useMaterial3: true,
    colorSchemeSeed: Color.fromARGB(255, 253, 93, 0),
    brightness: Brightness.dark,
    // colorScheme: darkColorScheme,
    iconTheme: IconThemeData(color: darkColorScheme.onPrimaryContainer));
