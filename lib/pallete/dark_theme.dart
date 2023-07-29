import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.orange),
      titleTextStyle: TextStyle(color: Colors.orange, fontSize: 16),
    ),
    colorScheme: ColorScheme.dark(
      background: Colors.black54,
      primary: Colors.grey[850]!,
      secondary: Colors.grey[800]!,
      surface: Colors.deepOrange,
      tertiary: Colors.white,
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: Colors.white)));
