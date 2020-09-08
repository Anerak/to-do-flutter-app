import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:todo_app/src/blocs/db_provider.dart';
import 'package:todo_app/src/blocs/tasks_bloc.dart';
import 'package:todo_app/src/widgets/menu_widget.dart';

class TodoListPage extends StatefulWidget {
  final String routeName = 'list-page';
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  String _title = '';
  String _date = '';
  String _time = '';
  int _order = 0;
  bool _ascOrder = true;

  bool _editMode = false;
  TaskModel _currentTask = new TaskModel();

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
        drawer: MenuWidget(),
        floatingActionButton: _speedDial(),
        body: CustomScrollView(
          slivers: [
            _addTaskHeader(),
            _tasksList(),
          ],
        ),
      ),
    );
  }

  SpeedDial _speedDial() {
    List<IconData> _icons = [
      Icons.format_list_bulleted,
      Icons.sort_by_alpha,
      Icons.access_time,
      Icons.date_range,
      Icons.done_all
    ];
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      closeManually: true,
      shape: CircleBorder(),
      marginBottom: MediaQuery.of(context).orientation == Orientation.portrait
          ? 20.0
          : 70.0,
      children: [
        SpeedDialChild(
          child: Icon(_ascOrder ? Icons.arrow_downward : Icons.arrow_upward),
          onTap: () => setState(() => _ascOrder = !_ascOrder),
        ),
        SpeedDialChild(
          child: Icon(_icons[_order]),
          onTap: () => setState(() {
            _order++;
            if (_order >= _icons.length) _order = 0;
          }),
        ),
      ],
    );
  }

  SliverAppBar _addTaskHeader() {
    return SliverAppBar(
      actions: [
        IconButton(
          icon: Icon(Icons.delete_forever),
          onPressed: () => _tasksBloc.deleteAllTasks(),
        ),
      ],
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
                autocorrect: false,
                controller: _textEditingController,
                keyboardType: TextInputType.text,
                maxLength: 250,
                maxLengthEnforced: true,
                onChanged: (value) => setState(() => _title = value.trim()),
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white60),
                  ),
                  counterStyle: TextStyle(color: Colors.white),
                  hintText: 'Task name',
                  hintStyle: TextStyle(color: Colors.white54),
                  prefixIcon: Icon(
                    Icons.assignment,
                    color: Theme.of(context).accentColor,
                  ),
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
                        Icon(
                          Icons.date_range,
                          color: Theme.of(context).accentColor,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          _date,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20.0),
                  InkWell(
                    onLongPress: () => setState(() => _time = ''),
                    onTap: () => _timePicker(context),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Theme.of(context).accentColor,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          _time,
                          style: TextStyle(color: Colors.white),
                        ),
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
                  _editMode ? Icons.edit : Icons.add_circle,
                  size: 40.0,
                  color: _title.trim() != ''
                      ? Theme.of(context).accentColor
                      : Theme.of(context).disabledColor,
                ),
                onTap: _title.trim() == ''
                    ? null
                    : () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        _submitTask();
                      },
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
        if (!snapshot.hasData || snapshot.data.length == 0)
          return SliverToBoxAdapter(
            // make sure to keep this SliverToBoxAdapter, otherwise the Center widget will make the app crash and we don't want that.
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "No pending tasks.\nTry adding one!",
                    style: TextStyle(fontSize: 20.0, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        final List<TaskModel> data = _orderList(snapshot.data, _order);
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) =>
                _listBuilder(context, data[index]),
            childCount: data.length == null ? 0 : data.length,
          ),
        );
      },
    );
  }

  Dismissible _listBuilder(BuildContext context, TaskModel task) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20.0),
        color: Colors.lightBlue,
        child: Icon(Icons.edit, color: Colors.white),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          _editTask(task);
        } else {
          _undoDelete(context, task);
          _tasksBloc.deleteTask(task.id);
        }
      },
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
        trailing: IconButton(
          icon: task.done == 0 ? Icon(Icons.cancel) : Icon(Icons.check_circle),
          onPressed: () => setState(() {
            if (task.done == 0) {
              task.done = 1;
            } else {
              task.done = 0;
            }
            _tasksBloc.updateTask(task);
          }),
        ),
        title: Text(task.title),
        subtitle: Text("${task.date} ${task.time}"),
      ),
    );
  }

  void _undoDelete(BuildContext context, TaskModel oldTask) {
    SnackBar _snackBar = SnackBar(
      content: Text('Task deleted!'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () => _tasksBloc.addTask(oldTask),
      ),
    );
    Scaffold.of(context).showSnackBar(_snackBar);
  }

  List<TaskModel> _orderList(List<TaskModel> inData, int orderValue) {
    List<TaskModel> outData = inData;
    switch (orderValue) {
      case 0: // simple ID order
        if (!_ascOrder) outData.sort((a, b) => b.id.compareTo(a.id));
        break;
      case 1: // String comparison
        outData.sort((a, b) => _ascOrder
            ? a.title.compareTo(b.title)
            : b.title.compareTo(a.title));
        break;
      case 2: // Time comparison
        outData.sort((a, b) =>
            _ascOrder ? a.time.compareTo(b.time) : b.time.compareTo(a.time));
        break;
      case 3: // Date comparison
        outData.sort((a, b) =>
            _ascOrder ? a.date.compareTo(b.date) : b.date.compareTo(a.date));
        break;
      case 4: // Done comparison
        outData.sort((a, b) =>
            _ascOrder ? a.done.compareTo(b.done) : b.done.compareTo(a.done));
        break;
      default:
    }
    return outData;
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

  void _editTask(TaskModel task) {
    setState(() {
      _currentTask = task;
      _editMode = true;
      _textEditingController.text = _currentTask.title;
      _title = _currentTask.title;
      _date = _currentTask.date;
      _time = _currentTask.time;
    });
  }

  void _updateCurrentTask() {
    _currentTask.title = _title;
    _currentTask.date = _date;
    _currentTask.time = _time;
  }

  void _submitTask() {
    _updateCurrentTask();
    if (_editMode) {
      _tasksBloc.updateTask(_currentTask);
    } else {
      _tasksBloc
          .addTask(new TaskModel(title: _title, date: _date, time: _time));
    }
    setState(() {
      _editMode = false;
      _currentTask = new TaskModel();
      _textEditingController.clear();
      _title = '';
      _date = '';
      _time = '';
    });
  }
}
