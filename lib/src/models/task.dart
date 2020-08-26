class TaskModel {
  int id;
  String title;
  String date;
  String time;

  TaskModel({this.id, this.title, this.date = '', this.time = ''});

  factory TaskModel.fromJson(Map<String, dynamic> json) => new TaskModel(
        id: json['id'],
        title: json['title'],
        date: json['date'],
        time: json['time'],
      );

  Map<String, dynamic> toJson() =>
      {'id': id, 'title': title, 'date': date, 'time': time};
}
