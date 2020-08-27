import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static final UserPrefs _instance = new UserPrefs._();
  factory UserPrefs() => _instance;
  UserPrefs._();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  get currentTheme {
    if ((_prefs.getBool('currentTheme') == null) ||
        (_prefs.getBool('currentTheme') == false)) {
      return ThemeData(
        primaryColor: Colors.purple,
        accentColor: Colors.white,
        hintColor: Colors.white,
        accentIconTheme: IconThemeData(color: Colors.purple),
      );
    } else {
      return ThemeData.dark();
    }
  }

  get currentThemeBool => _prefs.getBool('currentTheme');

  set currentTheme(bool value) {
    _prefs.setBool('currentTheme', value);
  }
}
