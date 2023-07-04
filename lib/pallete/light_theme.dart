import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.deepOrange),
      titleTextStyle: TextStyle(color: Colors.deepOrange, fontSize: 20),
    ),
    colorScheme: ColorScheme.light(
        background: Colors.grey[300]!,
        primary: Colors.grey[200]!,
        secondary: Colors.grey[300]!,
        surface: Colors.orange,
        tertiary: Colors.black),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: Colors.black)));
