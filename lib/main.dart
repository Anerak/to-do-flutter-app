import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/src/blocs/theme.dart';
import 'package:todo_app/src/models/userprefs.dart';
import 'package:todo_app/src/pages/list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserPrefs();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _prefs = new UserPrefs();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeChanger(_prefs.currentTheme),
      child: MateApp(),
    );
  }
}

class MateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.getTheme(),
      themeMode: ThemeMode.system,
      title: 'To-Do App',
      initialRoute: 'list-page',
      routes: {
        TodoListPage().routeName: (BuildContext context) => TodoListPage(),
      },
    );
  }
}
