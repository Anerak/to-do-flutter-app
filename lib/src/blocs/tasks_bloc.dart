import 'dart:async';
import 'package:todo_app/src/blocs/db_provider.dart';

class TasksBloc {
  static final TasksBloc _singleton = new TasksBloc._();

  factory TasksBloc() => _singleton;
  TasksBloc._() {
    this.getTasks();
  }

  StreamController _tasksController =
      new StreamController<List<TaskModel>>.broadcast();

  Stream<List<TaskModel>> get taskStream => _tasksController.stream;

  dispose() {
    _tasksController?.close();
  }

  getTasks() async {
    _tasksController.sink.add(await DBProvider.db.getAllTasks());
  }

  void addTask(TaskModel task) async {
    await DBProvider.db.newTask(task);
    this.getTasks();
  }

  void updateTask(TaskModel task) async {
    await DBProvider.db.updateTask(task);
    this.getTasks();
  }

  void deleteTask(int id) async {
    await DBProvider.db.deleteTask(id);
    this.getTasks();
  }

  void deleteAllTasks() async {
    await DBProvider.db.deleteAllTasks();
    this.getTasks();
  }
}
