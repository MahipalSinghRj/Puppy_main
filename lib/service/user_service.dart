import 'dart:convert';
import 'dart:developer';
import 'package:friday_v/Constants/api_constants.dart';
import 'package:friday_v/auth/sso.dart';
import 'package:friday_v/model/user.dart';
import 'package:friday_v/service/config.dart';
import 'package:friday_v/utils/status_code_constants.dart';
import 'package:friday_v/utils/shared_pref.dart';
import 'package:http/http.dart' as http;

import '../Debug/printme.dart';

class UserService {
  SharedPref shared = SharedPref();

  Future<UserModel> getPeople() async {
    UserModel result = UserModel();
    try {
      var token = await getToken();
      final response = await http.get(Uri.parse(ApiConstants.userProfile),
          headers: {"Content-Type": "application/json", 'Authorization': 'Bearer $token'});

      printMe("Status Code is : ${response.statusCode}");
      printMe("Get people response is : ${response.body}");

      switch (response.statusCode) {
        case OK:
          final item = json.decode(response.body);
          result = UserModel.fromJson(item);
          result.odataContext = token;
          break;
        case UNAUTHORIZED:
          Auth().refreshTokenResponse();
          getPeople();
          break;
      }
    } catch (e, r) {
      printError(e.toString());
      printError(r.toString());
    }
    return result;
  }

  Future<String> getToken() async {
    User user = User.fromJson(await shared.read("user"));
    return user.AccessToken.toString();
  }

  Future<String> getID() async {
    UserModel user = UserModel.fromJson(await shared.read("usermodel"));
    return user.id.toString();
  }

  Future<UserModel> getPeopleByID(userId) async {
    UserModel result = UserModel();
    try {
      var token = await getToken();
      final response = await http.get(Uri.parse("${ApiConstants.getPeopleById}users/$userId"),
          headers: {"Content-Type": "application/json", 'Authorization': 'Bearer $token'});
      printMe("Status Code is : ${response.statusCode}");
      printMe("Get people response is : ${response.body}");

      switch (response.statusCode) {
        case OK:
          final item = json.decode(response.body);
          result = UserModel.fromJson(item);
          result.odataContext = token;
          break;
        case UNAUTHORIZED:
          Auth().refreshTokenResponse();
          getPeopleByID(userId);
          break;
      }
    } catch (e, r) {
      printError(e.toString());
      printError(r.toString());
    }
    return result;
  }
}
