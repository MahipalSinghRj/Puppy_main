import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:friday_v/Constants/api_constants.dart';
import 'package:friday_v/auth/sso.dart';
import 'package:friday_v/model/task.dart';
import 'package:friday_v/model/user.dart';
import 'package:friday_v/service/config.dart';
import 'package:friday_v/utils/status_code_constants.dart';
import 'package:friday_v/utils/shared_pref.dart';
import 'package:http/http.dart' as http;
import '../Debug/printme.dart';

class TodoService {
  SharedPref shared = SharedPref();
  String taskList = '';

  Future<TaskListModel> getTaskList() async {
    List<TaskListModel> result = [];
    TaskListModel single = TaskListModel();
    try {
      var token = await getToken();
      final response = await http.get(
        Uri.parse(ApiConstants.taskList),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
      );
      log('response${response.body}');
      debugPrint('response${response.statusCode}');
      switch (response.statusCode) {
        case OK:
          final list = json.decode(response.body)["value"];
          result = list.map<TaskListModel>((json) => TaskListModel.fromJson(json)).toList();
          for (TaskListModel task in result) {
            if (task.displayName == "Tasks") {
              single = task;
              break;
            }
          }
          printMe("TASKLIST: ${result.length}");
          printMe("TASKLIST: $result");
          break;
        case UNAUTHORIZED:
          Auth().refreshTokenResponse();
          getTaskList();
          break;
        default:
          return single;
      }
    } catch (e) {
      log("getTaskList(): $e");
      return single;
    }
    return single;
  }

  Future<List<TaskModel>> getTasks(String taskID) async {
    List<TaskModel> result = [];
    List<TaskModel> result_ = [];
    taskList = taskID;

    try {
      var token = await getToken();
      final response = await http.get(
        Uri.parse("https://graph.microsoft.com/v1.0/me/todo/lists/$taskID/tasks?\$filter=status eq 'notStarted'"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case OK:
          final list = json.decode(response.body)["value"];
          result = list.map<TaskModel>((json) => TaskModel.fromJson(json)).toList();

          for (TaskModel task in result) {
            TaskModel tt = task;
            tt.odataEtag = taskID;
            result_.add(tt);
          }
          printMe(result_.length.toString());
          break;
        case UNAUTHORIZED:
          Auth().refreshTokenResponse();
          getTaskList();
          break;
        default:
          return result_;
      }
    } catch (e) {
      log("getTasks():$e");
      return result;
    }
    return result_;
  }

  Future<String> getToken() async {
    User user = User.fromJson(await shared.read("user"));
    return user.AccessToken.toString();
  }

  update(String key, String importance, String list_id, String id) async {
    Map<String, dynamic> body = {
      key: importance,
    };
    try {
      var token = await getToken();
      // log(token);
      final response = await http.patch(
        //Todo: Patch
        Uri.parse("https://graph.microsoft.com/v1.0/me/todo/lists/$list_id/tasks/$id"),
        body: json.encode(body),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      printMe(response.body);

      switch (response.statusCode) {
        case OK:
          printMe('updated');
          break;
        case UNAUTHORIZED:
          Auth().refreshTokenResponse();
          getTaskList();
          break;
        default:
          return;
      }
    } catch (e) {
      log("getTasks():$e");
    }
  }

  Future<String> updateBody(String body, String listId, String id) async {
    Map<String, dynamic> main = {
      'content': body,
      'contentType': 'text',
    };

    Map<String, dynamic> map = {'body': main};

    String updated = '';

    try {
      var token = await getToken();
      // log(token);
      final response = await http.patch(
        //Todo: Patch
        Uri.parse("https://graph.microsoft.com/v1.0/me/todo/lists/$listId/tasks/$id"),
        body: json.encode(map),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      printMe(response.body);

      switch (response.statusCode) {
        case OK:
          var json = jsonDecode(response.body);
          updated = json['body']['content'];
          break;
        case UNAUTHORIZED:
          updated = '';
          break;
      }

      return updated;
    } catch (e) {
      log("getTasks():$e");
      return updated;
    }
  }
}
