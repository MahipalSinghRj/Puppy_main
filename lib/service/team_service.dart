import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:friday_v/auth/sso.dart';
import 'package:friday_v/model/team.dart';
import 'package:friday_v/model/user.dart';
import 'package:friday_v/service/config.dart';
import 'package:friday_v/utils/constants.dart';
import 'package:friday_v/utils/shared_pref.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class TeamService {
  SharedPref shared = SharedPref();

  late List<TeamModel> sites;




  Future<List<TeamModel>> getTeamLocation() async {
    // make request
    Response response = await get(
        Uri.parse('http://track.smart-tech.melbourne/getSessions'),);

    // sample info available in response
    int statusCode = response.statusCode;
    String raw = response.body;
    log( response.body);


     var data = json.decode(raw);

     var team = data as List;
     debugPrint('team${team.length}');
     for(var i=0;i<team.length;i++){
       var userid = team[i]['user_id'].toString().replaceAll(' ', '');
       debugPrint('user id$userid');
       team[i]["imgUrl"]= "https://graph.microsoft.com/v1.0/users/$userid/photo/\$value";
       debugPrint('team imgUrl${team[i]['imgUrl'].toString()}');
     }


   // var json = jsonDecode(response.body);
    //var team = json as List;
    sites = team.map<TeamModel>((json) => TeamModel.fromJson(json)).toList();

    return sites;
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