import 'package:flutter/material.dart';
import 'package:todo_app/src/pages/list_page.dart';
import 'package:todo_app/src/widgets/theme_switch.dart';

class MenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: Icon(Icons.check_circle),
            title: Text("To Do App"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.view_list),
            title: Text("Tasks"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(TodoListPage().routeName),
          ),
          ThemeSwitch(),
        ],
      ),
    );
  }
}
