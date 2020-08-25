import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoListPage extends StatefulWidget {
  final String routeName = 'list-page';
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  String _title = '';
  String _date = '';
  String _time = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            _addHeader(),
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return Container(
                  child: Text(index.toString()),
                );
              }, childCount: 30),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _addHeader() {
    return SliverAppBar(
      expandedHeight: 200.0,
      pinned: true,
      floating: true,
      snap: false,
      title: Text('Tasks'),
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height: 30.0,
              ),
              TextField(
                keyboardType: TextInputType.text,
                maxLength: 140,
                maxLengthEnforced: true,
                onChanged: (value) => setState(() => _title = value.trim()),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.assignment),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      _datePicker(context);
                    },
                  ),
                  Text(_date),
                  IconButton(
                    icon: Icon(Icons.watch_later),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      _timePicker(context);
                    },
                  ),
                  Text(_time),
                  SizedBox(width: 40.0),
                  IconButton(
                    icon: Icon(Icons.add_circle),
                    onPressed: () {},
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _datePicker(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate,
      lastDate: new DateTime(currentDate.year + 3),
    );

    if (picked != null) {
      setState(() {
        _date = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void _timePicker(BuildContext context) async {
    TimeOfDay currentTime = TimeOfDay.now();
    TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: currentTime.hour, minute: currentTime.minute + 5),
      cancelText: '',
    );

    if (picked != null) {
      setState(() {
        _time = "${picked.hour}:${picked.minute}";
      });
    }
  }
}
