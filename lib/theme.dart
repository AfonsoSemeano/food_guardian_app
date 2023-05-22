import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  textTheme: GoogleFonts.openSansTextTheme(),
  primaryColorDark: const Color(0xFF0097A7),
  primaryColorLight: const Color(0xFFB2EBF2),
  primaryColor: const Color(0xFFFFFFFF),
  colorScheme: const ColorScheme.light(
    secondary: Color(0xFF32CD32),
    error: Colors.red,
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Color(0xFF32CD32),
    selectionColor: Color.fromARGB(255, 180, 252, 98),
    selectionHandleColor: Color(0xFF32CD32),
  ),
  scaffoldBackgroundColor: const Color(0xFFE8F5E9),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);

final theme1 = ThemeData(
  textTheme: GoogleFonts.openSansTextTheme(),
  primaryColorDark: const Color(0xFF0097A7),
  primaryColorLight: const Color(0xFFB2EBF2),
  primaryColor: const Color(0xFFFFFFFF),
  colorScheme: const ColorScheme.light(
    secondary: Color(0xFF009688),
    error: Colors.red,
  ),
  scaffoldBackgroundColor: const Color(0xFFE0F2F1),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
