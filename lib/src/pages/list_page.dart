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
    //_tasksBloc.addTask(new TaskModel(id: 10, title: 'Hey', date: '28-07-2200', time: '13:50'));
    _tasksBloc.getTasks();
    return SafeArea(
      child: Scaffold(
          body: CustomScrollView(
        slivers: [
          _addTaskHeader(),
          StreamBuilder(
            stream: _tasksBloc.taskStream,
            builder: (BuildContext context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: Text('No pending tasks'),
                );
              final List<TaskModel> data = snapshot.data;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return ListTile(
                      title: Text(data[index].title),
                      subtitle:
                          Text("${data[index].date} - ${data[index].time}"),
                    );
                  },
                  childCount: data.length,
                ),
              );
            },
          )
        ],
      )
          /*CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            _addTaskHeader(),
            _tasksList(),
          ],
        ),*/
          /*StreamBuilder(
          stream: _tasksBloc.taskStream,
          builder:
              (BuildContext context, AsyncSnapshot<List<TaskModel>> snapshot) {
            if (!snapshot.hasData) return Center(child: Text("No data"));
            List<TaskModel> data = snapshot.data;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(data[index].title),
                subtitle: Text(data[index].id.toString()),
              ),
            );
          },
        ),*/
          ),
    );
  }

  _bar() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot<List<TaskModel>> snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: Text('No pending tasks!'),
          );
        return ListView.builder(
          itemBuilder: (context, index) => ListTile(),
        );
      },
      stream: _tasksBloc.taskStream,
    );
  }

  _foo() {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          StreamBuilder(
            stream: _tasksBloc.taskStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<TaskModel>> snapshot) {
              if (!snapshot.hasData)
                return Center(child: Text('No tasks pending!'));
              final data = snapshot.data;
              return SliverToBoxAdapter(
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) => ListTile(
                    title: Text(data[index].title),
                    subtitle: Text("ID: ${data[index].id}"),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  _tasksList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => StreamBuilder(
          stream: _tasksBloc.taskStream,
          builder:
              (BuildContext context, AsyncSnapshot<List<TaskModel>> snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: Text('No tasks pending'),
              );
            final List<TaskModel> data = snapshot.data;
            print(data);
          },
        ),
      ),
    );
  }

  _tasks2List() {
    StreamBuilder<List<TaskModel>>(
      stream: _tasksBloc.taskStream,
      builder: (BuildContext context, AsyncSnapshot<List<TaskModel>> snapshot) {
        print(_tasksBloc.taskStream);
        if (!snapshot.hasData || snapshot.data[0] == null)
          return Center(
            child: Text("Loading"),
          );
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return ListTile();
            },
            childCount: snapshot.data.length,
          ),
        );
      },
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
    setState(() {
      _textEditingController.clear();
      _title = '';
      _date = '';
      _time = '';
    });
  }
}
