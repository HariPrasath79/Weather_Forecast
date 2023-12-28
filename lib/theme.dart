import 'package:flutter/material.dart';

class Styles {
  static ThemeData isDarkTheme(bool isdark) {
    return isdark
        ? ThemeData.dark(
            useMaterial3: true,
          )
        : ThemeData.light(
            useMaterial3: true,
          );
    print(isdark);
  }
}
