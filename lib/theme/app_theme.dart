import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0F1115),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0F1115),
      centerTitle: true,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.dark(
      primary: Colors.redAccent,
      secondary: Colors.red,
    ),
  );
}