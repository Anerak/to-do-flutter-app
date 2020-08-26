import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/src/blocs/db_provider.dart';
import 'package:todo_app/src/blocs/tasks_bloc.dart';

class TodoListPage extends StatefulWidget {
  final String routeName = 'list-page';
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  String _title = '';
  String _date = '';
  String _time = '';

  TextEditingController _textEditingController = new TextEditingController();

  final _tasksBloc = new TasksBloc();
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tasksBloc.getTasks();
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            _addTaskHeader(),
            _tasksList(),
          ],
        ),
      ),
    );
  }

  SliverAppBar _addTaskHeader() {
    return SliverAppBar(
      expandedHeight: 250.0,
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
                controller: _textEditingController,
                keyboardType: TextInputType.text,
                maxLength: 140,
                maxLengthEnforced: true,
                onChanged: (value) => setState(() => _title = value.trim()),
                decoration: InputDecoration(
                  hintText: 'Task name',
                  prefixIcon: Icon(Icons.assignment),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onLongPress: () => setState(() => _date = ''),
                    onTap: () => _datePicker(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.date_range),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(_date),
                      ],
                    ),
                  ),
                  SizedBox(width: 20.0),
                  InkWell(
                    onLongPress: () => setState(() => _time = ''),
                    onTap: () => _timePicker(context),
                    child: Row(
                      children: [
                        Icon(Icons.access_time),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(_time),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              InkWell(
                child: Icon(
                  Icons.add_circle,
                  size: 40.0,
                  color: _title.trim() != '' ? Colors.red : Colors.blue,
                ),
                onTap: _title.trim() != '' ? _submitTask : null,
              )
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<List<TaskModel>> _tasksList() {
    return StreamBuilder(
      stream: _tasksBloc.taskStream,
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData)
          return SliverToBoxAdapter(
            // make sure to keep this SliverToBoxAdapter, otherwise the Center widget will make the app crash and we don't want that.
            child: Center(
              child: Text('No pending tasks'),
            ),
          );
        final List<TaskModel> data = snapshot.data;
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Dismissible(
                key: UniqueKey(),
                child: ListTile(
                  title: Text(data[index].title),
                  subtitle: Text("${data[index].date} ${data[index].time}"),
                ),
              );
            },
            childCount: data.length == null ? 0 : data.length,
          ),
        );
      },
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

  void _submitTask() {
    _tasksBloc.addTask(new TaskModel(title: _title, date: _date, time: _time));
    setState(() {
      _textEditingController.clear();
      _title = '';
      _date = '';
      _time = '';
    });
  }
}
