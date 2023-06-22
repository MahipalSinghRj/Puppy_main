import 'dart:convert';

OrganizationModel organizationModelFromJson(String str) => OrganizationModel.fromJson(json.decode(str));

class OrganizationModel {
  OrganizationModel({
    this.orgId,
    this.orgName,
    this.email,
    this.phone,
    this.firstName,
    this.lastName,
  });

  String? orgId;
  String? orgName;
  String? email;
  String? phone;
  String? firstName;
  String? lastName;

  factory OrganizationModel.fromJson(Map<String, dynamic> json) => OrganizationModel(
    orgId: json["org_id"],
    orgName: json["org_name"],
    email: json["email"],
    phone: json["phone"],
    firstName: json["first_name"],
    lastName: json["last_name"],
  );
}

class JobType {
  final String? typeName;
  final String? typeID;

  JobType({
    this.typeName,
    this.typeID,
  });

  factory JobType.fromJson(Map<String, dynamic> json) {
    return JobType(
      typeName: json['typeName'] as String,
      typeID: json['typeID'] as String,
    );
  }
}

List<Session> sessionFromJson(String str) =>
    List<Session>.from(json.decode(str).map((x) => Session.fromJson(x)));

class Session {
  Session({
    required this.logId,
    required this.inTime,
    required this.siteRep,
    required this.visitDate,
    required this.breakOut,
    required this.orgName,
    required this.siteAddress,
    required this.typeName,
    required this.inBreak,
  });

  String logId;
  String inTime;
  String siteRep;
  String visitDate;
  String breakOut;
  String orgName;
  String siteAddress;
  String typeName;
  String inBreak;

  factory Session.fromJson(Map<String, dynamic> json) => Session(
    logId: json["log_id"],
    inTime: json["in_time"],
    siteRep: json["site_rep"],
    visitDate: json["visit_date"],
    breakOut: json["break_out"],
    orgName: json["org_name"],
    siteAddress: json["site_address"],
    typeName: json["type_name"],
    inBreak: json["in_break"],
  );
}
