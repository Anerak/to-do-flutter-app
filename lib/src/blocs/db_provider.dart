import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:todo_app/src/models/task.dart';
export 'package:todo_app/src/models/task.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;
    return _database = await startDB();
  }

  startDB() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    final path = join(docDir.path, 'TodoDBApp.db');

    return await openDatabase(
      path,
      version: 2,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE Tasks ('
            'id INTEGER PRIMARY KEY,'
            'title TEXT,'
            'date TEXT,'
            'time TEXT,'
            'done INTEGER'
            ')');
        await db.insert(
            'Tasks',
            new TaskModel(
                    title: 'Add a new task!',
                    date: '01-01-2020',
                    time: '13:55',
                    done: 0)
                .toJson());
      },
    );
  }

  Future<String> newTask(TaskModel task) async {
    final Database db = await database;
    final int res = await db.insert('Tasks', task.toJson());
    if (res == 0) return "Error adding a new task.";
    return "Task added successfully!";
  }

  Future<List<TaskModel>> getAllTasks() async {
    final Database db = await database;
    final res = await db.query('Tasks');
    List<TaskModel> response = res.isNotEmpty
        ? res.map((task) => TaskModel.fromJson(task)).toList()
        : [];
    return response;
  }

  Future<int> updateTask(TaskModel task) async {
    final Database db = await database;
    final res = await db
        .update('Tasks', task.toJson(), where: 'id = ?', whereArgs: [task.id]);
    return res;
  }

  Future<int> deleteTask(int id) async {
    final Database db = await database;
    final int res = await db.delete('Tasks', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAllTasks() async {
    final Database db = await database;
    final int res = await db.delete('Tasks');
    return res;
  }
}
