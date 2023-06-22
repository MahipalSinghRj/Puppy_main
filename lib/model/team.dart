
import 'dart:convert';

List<TeamModel> teamModelFromJson(String str) => List<TeamModel>.from(json.decode(str).map((x) => TeamModel.fromJson(x)));

class TeamModel {
  TeamModel({
    this.logId = '',
    this.orgId = '',
    this.siteId = '',
    this.userId = '',
    this.typeId = '',
    this.inTime = '',
    this.outTime = '',
    this.description = '',
    this.siteRep = '',
    this.visitDate = '',
    this.repUrl = '',
    this.breakOut = '',
    this.breakIn = '',
    this.totalTime = '',
    this.totalBreak = '',
    this.sessionLive = '',
    this.inBreak = '',
    this.inLatLng = '',
    this.outLatLng = '',
    this.hash = '',
    this.siteAddress = '',
    this.siteLat = '',
    this.siteLng = '',
    this.orgName = '',
    this.email = '',
    this.phone = '',
    this.firstName = '',
    this.lastName = '',
    this.typeName = '',
    this.imgUrl ="",

  });

  String logId;
  String orgId;
  String siteId;
  String userId;
  String typeId;
  String inTime;
  String outTime;
  String description;
  String siteRep;
  String visitDate;
  String repUrl;
  String breakOut;
  String breakIn;
  String totalTime;
  String totalBreak;
  String sessionLive;
  String inBreak;
  String inLatLng;
  String outLatLng;
  String hash;
  String siteAddress;
  String siteLat;
  String siteLng;
  String orgName;
  String email;
  String phone;
  String firstName;
  String lastName;
  String typeName;
  String imgUrl;

  factory TeamModel.fromJson(Map<String, dynamic> json) => TeamModel(
    logId: json["log_id"],
    orgId: json["org_id"],
    siteId: json["site_id"],
    userId: json["user_id"],
    typeId: json["type_id"],
    inTime: json["in_time"],
    outTime: json["out_time"],
    description: json["description"],
    siteRep: json["site_rep"],
    visitDate: json["visit_date"],
    repUrl: json["rep_url"],
    breakOut: json["break_out"],
    breakIn: json["break_in"],
    totalTime: json["total_time"],
    totalBreak: json["total_break"],
    sessionLive: json["session_live"],
    inBreak: json["in_break"],
    inLatLng: json["in_lat_lng"],
    outLatLng: json["out_lat_lng"],
    hash: json["hash"],
    siteAddress: json["site_address"],
    siteLat: json["site_lat"],
    siteLng: json["site_lng"],
    orgName: json["org_name"],
    email: json["email"],
    phone: json["phone"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    typeName: json["type_name"],
    imgUrl: json["imgUrl"],
  );
}
