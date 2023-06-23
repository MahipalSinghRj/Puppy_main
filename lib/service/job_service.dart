import 'dart:convert';
import 'package:friday_v/Constants/api_constants.dart';
import 'package:friday_v/model/location.dart';
import 'package:friday_v/model/org.dart';
import 'package:friday_v/service/user_service.dart';
import 'package:http/http.dart';
import '../Debug/printme.dart';

class JobService {

  Future<List<OrganizationModel>> getOrganization() async {
    try {
      Response response = await post(Uri.parse(ApiConstants.getOrganization));
      printMe("Status Code is : ${response.statusCode}");
      printMe("Get organization response is : ${response.body}");
      if (response.statusCode == 200) {
        String raw = response.body;
        var json = jsonDecode(raw);
        var job = json['org'] as List;
        List<OrganizationModel> orgs = job.map<OrganizationModel>((json) => OrganizationModel.fromJson(json)).toList();
        return orgs;
      } else {
        throw Exception('Received status code ${response.statusCode}');
      }
    } catch (e, r) {
      printError("Error get organization: ${e.toString()}");
      printError(r.toString());
      return [];
    }
  }

  Future<List<Site>> getSites(String id) async {
    try {
      Response response = await post(Uri.parse(ApiConstants.getSites), body: {"org_id": id});
      printMe("Status Code is : ${response.statusCode}");
      printMe("Get Sites response is : ${response.body}");
      if (response.statusCode == 200) {
        String raw = response.body;
        var json = jsonDecode(raw);
        var job = json['site'] as List;
        List<Site> sites = job.map<Site>((json) => Site.fromJson(json)).toList();
        return sites;
      } else {
        throw Exception('Received status code ${response.statusCode}');
      }
    } catch (e, r) {
      printError("Error get sites: ${e.toString()}");
      printError(r.toString());
      return [];
    }
  }

  Future<List<JobType>> fetchList() async {
    try {
      Response response = await post(Uri.parse(ApiConstants.fetchList));
      printMe("Status Code is : ${response.statusCode}");
      printMe("Fetch List response is : ${response.body}");

      if (response.statusCode == 200) {
        String raw = response.body;
        var json = jsonDecode(raw);
        var job = json['job'] as List;
        List<JobType> itemList = [];

        for (int i = 1; i < job.length; i++) {
          itemList.add(JobType(typeID: job[i]['type_id'], typeName: job[i]['type_name']));
        }
        return itemList;
      } else {
        throw Exception('Received status code ${response.statusCode}');
      }
    } catch (e, r) {
      printError("Error Fetch List: ${e.toString()}");
      printError(r.toString());
      return [];
    }
  }

  Future<List<Session>> getSessions() async {
    String id = await UserService().getID();
    printMe("ID is: $id");
    try {
      Response response = await post(Uri.parse(ApiConstants.getSession), body: {"user_id": id});
      printMe("Status Code is : ${response.statusCode}");
      printMe("Get Session response is : ${response.body}");
      if (response.statusCode == 200) {
        String raw = response.body;
        var json = jsonDecode(raw);
        var job = json as List;
        List<Session> session = job.map<Session>((json) => Session.fromJson(json)).toList();
        return session;
      } else {
        throw Exception('Received status code ${response.statusCode}');
      }
    } catch (e, r) {
      printError("Error Get Session : ${e.toString()}");
      printError(r.toString());
      return [];
    }
  }
}
