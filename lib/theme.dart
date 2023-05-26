import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  textTheme: GoogleFonts.openSansTextTheme(),
  primaryColorDark: const Color(0xFF0097A7),
  primaryColorLight: const Color(0xFFB2EBF2),
  primaryColor: const Color(0xFFFFFFFF),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFFFFFFFF),
    secondary: Color(0xFF32CD32),
    error: Colors.red,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color(0xFF32CD32),
    selectionColor: Color.fromARGB(255, 180, 252, 98),
    selectionHandleColor: Color(0xFF32CD32),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey; // Customize the disabled color
          }
          return const Color(0xFF32CD32); // Customize the enabled color
        },
      ),
    ),
  ),
  chipTheme: const ChipThemeData(
    selectedColor: Color(0xFF32CD32),
    secondaryLabelStyle: TextStyle(color: Colors.white),
  ),
  scaffoldBackgroundColor: const Color(0xFFE8F5E9),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    floatingLabelStyle: const TextStyle(
      color: Color(0xFF32CD32),
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
