import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:friday_v/model/user.dart';
import 'package:friday_v/service/user_service.dart';
import 'package:friday_v/utils/shared_pref.dart';

class UserProvider with ChangeNotifier {
  UserModel post = UserModel();
  bool loading = false;
  var token = "";

  getUserData(context) async {
    loading = true;
    post = await UserService().getPeople();
    loading = false;
    notifyListeners();
  }

  getAccessToken(context) async {
    loading = true;
    var user = await SharedPref().read("user");
    token = user.AccessToken;
    loading = false;
    notifyListeners();
  }

  getUserByID(context, userId) async {
    loading = true;
    post = await UserService().getPeopleByID(userId);
    loading = false;
    notifyListeners();
  }
}