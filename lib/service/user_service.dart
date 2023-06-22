import 'dart:convert';
import 'dart:developer';

import 'package:friday_v/auth/sso.dart';
import 'package:friday_v/model/user.dart';
import 'package:friday_v/service/config.dart';
import 'package:friday_v/utils/constants.dart';
import 'package:friday_v/utils/shared_pref.dart';
import 'package:http/http.dart' as http;

class UserService {
  SharedPref shared = SharedPref();

  Future<UserModel> getPeople() async {
    UserModel result = UserModel();
    // try {
    var token = await getToken();
    final response = await http.get( //Todo: GET
      Config.user_profile,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    print(response.body);


    switch(response.statusCode)
    {
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
    // } catch (e) {
    //   log(e.toString());
    // }
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
      final response = await http.get( //Todo: GET
        Uri.parse("https://graph.microsoft.com/v1.0/users/$userId"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      switch(response.statusCode)
      {
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
    } catch (e) {
      log(e.toString());
    }
    return result;

  }
}
/*
  Future<UserModel> getPeople() async {
    UserModel result = UserModel();
    try {
      var token = await getToken();
      final response = await http.get(
        Config.user_profile,
            headers: {
              "Content-Type": "image/jpeg",
              'Authorization': 'Bearer $token',
            },
      );

      if (response.statusCode == OK) {
        final item = json.decode(response.body);
        result = UserModel.fromJson(item);
        result.odataContext = token;
      } else {

      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  }
* */