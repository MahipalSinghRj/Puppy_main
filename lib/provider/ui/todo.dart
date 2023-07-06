import 'package:flutter/material.dart';
import 'package:friday_v/model/task.dart';
import 'package:friday_v/service/task_service.dart';

class TodoProvider with ChangeNotifier {
  List<TaskModel> tasks = [];
  TaskListModel taskList = TaskListModel();
  bool loading = false;

  Future<List<TaskModel>> getTaskList() async {
    debugPrint("Todo task list called : ");
    loading = true;
    taskList = await TodoService().getTaskList();
    tasks = await TodoService().getTasks(taskList.id);
    loading = false;
    notifyListeners();
    return tasks;
  }
}
