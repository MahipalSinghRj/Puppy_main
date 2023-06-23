import 'dart:convert';
import 'package:friday_v/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  read(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key)!);
  }

  save(String key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  savebool(String key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  Future<String> readRefresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User user = prefs.getString('user') != null
        ? User.fromJson(json.decode(prefs.getString('user')!))
        : User.fromJson(json.decode(jsonEncode({"AccessToken": "", "IDToken": "", "RefreshToken": ""})));
    return user.RefreshToken;
  }
}
