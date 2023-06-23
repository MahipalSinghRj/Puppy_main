import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:friday_v/Constants/api_constants.dart';
import 'package:friday_v/model/team.dart';
import 'package:friday_v/model/user.dart';
import 'package:friday_v/utils/shared_pref.dart';
import 'package:http/http.dart';

import '../Debug/printme.dart';

class TeamService {
  SharedPref shared = SharedPref();

  late List<TeamModel> sites;

  Future<List<TeamModel>> getTeamLocation() async {
    try {
      // Make request
      Response response = await get(Uri.parse(ApiConstants.getSession));
      printMe("Status Code is : ${response.statusCode}");
      printMe("Team model response is : ${response.body}");
      if (response.statusCode == 200) {
        String raw = response.body;
        var data = json.decode(raw);
        var team = data as List;
        debugPrint('Team : ${team.length}');

        for (var i = 0; i < team.length; i++) {
          var userid = team[i]['user_id'].toString().replaceAll(' ', '');
          debugPrint('user id$userid');
          team[i]["imgUrl"] = "https://graph.microsoft.com/v1.0/users/$userid/photo/\$value";
          debugPrint('team imgUrl${team[i]['imgUrl'].toString()}');
        }

        sites = team.map<TeamModel>((json) => TeamModel.fromJson(json)).toList();

        return sites;
      } else {
        throw Exception('Received status code : ${response.statusCode}');
      }
    } catch (e, r) {
      printError("Error Team model data : ${e.toString()}");
      printError(r.toString());
      return [];
    }
  }

  Future<String> getToken() async {
    User user = User.fromJson(await shared.read("user"));
    return user.AccessToken.toString();
  }

  Future<String> getID() async {
    UserModel user = UserModel.fromJson(await shared.read("usermodel"));
    return user.id.toString();
  }
}
