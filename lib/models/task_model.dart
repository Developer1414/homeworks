import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Task extends GetxController {
  final String titleTask;
  final String task;
  bool importantTask;
  final Color taskTitleColor;
  final DateTime date;
  int notificationId = 0;

  Task(
      {this.titleTask = '',
      this.task = '',
      this.notificationId = 0,
      this.importantTask = false,
      this.taskTitleColor = Colors.blueAccent,
      required this.date});

  factory Task.fromJson(Map<String, dynamic> jsonData) {
    String valueString =
        jsonData['taskTitleColor'].split('(0x')[1].split(')')[0];
    int value = int.parse(valueString, radix: 16);

    return Task(
      titleTask: jsonData['titleTask'],
      task: jsonData['task'],
      notificationId: int.parse(jsonData['notificationId']),
      importantTask: jsonData['importantTask'] as bool,
      taskTitleColor: Color(value),
      date: DateTime.parse(jsonData['date']),
    );
  }

  static Map<String, dynamic> toMap(Task task) => {
        'titleTask': task.titleTask,
        'task': task.task,
        'notificationId': task.notificationId.toString(),
        'importantTask': task.importantTask,
        'taskTitleColor': task.taskTitleColor.toString(),
        'date': task.date.toString(),
      };

  static String encode(List<Task> task) => json.encode(
        task.map<Map<String, dynamic>>((t) => Task.toMap(t)).toList(),
      );

  static List<Task> decode(String val) => (json.decode(val) as List<dynamic>)
      .map<Task>((item) => Task.fromJson(item))
      .toList();
}
