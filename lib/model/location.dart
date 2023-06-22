import 'dart:convert';

Site siteFromJson(String str) => Site.fromJson(json.decode(str));

class Site {
  Site({
    this.orgId,
    this.siteId,
    this.siteAddress,
    this.siteLat,
    this.siteLng,
  });

  String? orgId;
  String? siteId;
  String? siteAddress;
  String? siteLat;
  String? siteLng;

  factory Site.fromJson(Map<String, dynamic> json) => Site(
    orgId: json["org_id"],
    siteId: json["site_id"],
    siteAddress: json["site_address"],
    siteLat: json["site_lat"],
    siteLng: json["site_lng"],
  );
}