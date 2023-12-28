import 'package:flutter/cupertino.dart';
import 'package:weather_app/theme_pref.dart';

class DarkThemeProvider with ChangeNotifier {
  DarkThemePref darkThemePrefs = DarkThemePref();
  bool darkTheme = false;
  bool get getDarktheme => darkTheme;

  set setDarkTheme(bool value) {
    darkTheme = value;
    darkThemePrefs.setDarkTheme(value);
    notifyListeners();
  }
}
