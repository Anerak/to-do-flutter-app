class TaskModel {
  int id;
  String title;
  String date;
  String time;
  int done;

  TaskModel(
      {this.id, this.title, this.date = '', this.time = '', this.done = 0});

  factory TaskModel.fromJson(Map<String, dynamic> json) => new TaskModel(
      id: json['id'],
      title: json['title'],
      date: json['date'],
      time: json['time'],
      done: json['done']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'title': title, 'date': date, 'time': time, 'done': done};
}
