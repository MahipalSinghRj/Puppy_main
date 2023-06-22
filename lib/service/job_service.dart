import 'dart:convert';
import 'dart:developer';
import 'package:friday_v/model/location.dart';
import 'package:friday_v/model/org.dart';
import 'package:friday_v/service/user_service.dart';
import 'package:http/http.dart';

class JobService {
  late List<OrganizationModel> orgs;
  late List<Site> sites;
  Future<List<OrganizationModel>> getOrgs() async {
    // make request
    Response response =
        await post(Uri.parse('http://track.smart-tech.melbourne/init'));
    // sample info available in response
    int statusCode = response.statusCode;
    String raw = response.body;
    var json = jsonDecode(raw);
    var job = json['org'] as List;
    orgs = job
        .map<OrganizationModel>((json) => OrganizationModel.fromJson(json))
        .toList();
    return orgs;
  }
  Future<List<Site>> getSites(String id) async {
    // make request
    Response response = await post(
        Uri.parse('http://track.smart-tech.melbourne/getSite'),
        body: {"org_id": id});

    // sample info available in response
    int statusCode = response.statusCode;
    String raw = response.body;
    var json = jsonDecode(raw);
    var job = json['site'] as List;
    sites = job.map<Site>((json) => Site.fromJson(json)).toList();
    return sites;
  }

  Future<List<JobType>> fetchList() async {
    // make request
    Response response =
        await post(Uri.parse('http://track.smart-tech.melbourne/init'));
    String raw = response.body;
    var json = jsonDecode(raw);

    var job = json['job'] as List;
    List<JobType> itemList = [];

    for (int i = 1; i < job.length; i++) {
      itemList.add(
          JobType(typeID: job[i]['type_id'], typeName: job[i]['type_name']));
    }
    // print(itemList);
    return itemList;
  }


  late List<Session> session = [];
  late String UID;

  Future<List<Session>> getSessions() async {
    // make request
    String id = await UserService().getID();

    print("ID IS: " + id.toString());

    try {
      Response response = await post(
          Uri.parse('http://track.smart-tech.melbourne/getSession'),
          body: {"user_id": id});
      // sample info available in response
      // int statusCode = response.statusCode;
      // print("statusCode..." + statusCode.toString());
      String raw = response.body;
        log('response${response.body}');
      var json = jsonDecode(raw);
      var job = json as List;
      session = job.map<Session>((json) => Session.fromJson(json)).toList();

      return session;
    } catch (e) {
      print(e.toString());
      return session;
    }
  }
  // getUserPref() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   UID = prefs.getString('UID') == "0" ? "0" : "1";
  //   return UID;
  // }
}
