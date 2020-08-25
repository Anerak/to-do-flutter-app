import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/src/blocs/theme.dart';
import 'package:todo_app/src/pages/list_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeChanger(ThemeData.dark()),
      child: MateApp(),
    );
  }
}

class MateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);

    return MaterialApp(
      theme: theme.getTheme(),
      title: 'To-Do App',
      initialRoute: 'list-page',
      routes: {
        TodoListPage().routeName: (BuildContext context) => TodoListPage(),
      },
    );
  }
}
