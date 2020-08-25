import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;

  ThemeChanger(this._themeData);

  getTheme() => this._themeData;

  setTheme(ThemeData theme) {
    this._themeData = theme;
    notifyListeners();
  }
}
