import 'package:flutter/material.dart';
import 'package:todo_app/src/pages/list_page.dart';
import 'package:todo_app/src/widgets/theme_switch.dart';

class MenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ScrollConfiguration(
        behavior: ScrollCustomBehavior(),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text("To Do App"),
              onTap: () => showAboutDialog(
                  context: context,
                  applicationVersion: "1.3",
                  children: <Widget>[Text('App created by Anerak.')]),
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
      ),
    );
  }
}

class ScrollCustomBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
