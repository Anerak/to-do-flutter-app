import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/src/blocs/theme.dart';
import 'package:todo_app/src/models/userprefs.dart';

class ThemeSwitch extends StatefulWidget {
  @override
  _ThemeSwitchState createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  final UserPrefs _prefs = new UserPrefs();
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(
        Icons.brightness_6,
      ),
      value: _prefs.currentThemeBool == null ? false : _prefs.currentThemeBool,
      title: Text("Dark theme"),
      onChanged: (value) => setState(() {
        _prefs.currentTheme = value;
        Provider.of<ThemeChanger>(context, listen: false)
            .setTheme(_prefs.currentTheme);
      }),
    );
  }
}
