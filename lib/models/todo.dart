import 'package:flutter/widgets.dart';

class Todo {
  int id;
  String userId;
  String task;
  bool isComplete;
  DateTime insertedAt;

  Todo(
      {this.id,
      @required this.userId,
      @required this.task,
      @required this.isComplete,
      this.insertedAt});

  factory Todo.fromJson(Map<String, dynamic> map) {
    return Todo(
        id: map['id'],
        userId: map['user_id'],
        task: map['task'],
        isComplete: map['is_complete'],
        insertedAt: DateTime.parse(map['inserted_at']));
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'task': task,
        'is_complete': isComplete,
      };
}
