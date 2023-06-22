import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.AccessToken,
    required this.IDToken,
    required this.RefreshToken
  });

  String AccessToken;
  String IDToken;
  String RefreshToken;

  factory User.fromJson(Map<String, dynamic> json) => User(
      AccessToken: json["AccessToken"],
      IDToken: json["IDToken"],
      RefreshToken: json["RefreshToken"]
  );

  Map<String, dynamic> toJson() => {
    "AccessToken": AccessToken,
    "IDToken": IDToken,
    "RefreshToken": RefreshToken
  };
}

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.odataContext = '',
    this.odataId = '',
    // this.businessPhones = '',
    this.displayName = '',
    this.givenName = '',
    this.jobTitle = '',
    this.mail = '',
    this.surname = '',
    this.userPrincipalName = '',
    this.id = '',
  });

  String odataContext;
  String odataId;
  // List<dynamic> businessPhones;
  String displayName;
  String givenName;
  String jobTitle;
  String mail;
  String surname;
  String userPrincipalName;
  String id;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    odataContext: json["@odata.context"],
    // businessPhones: List<dynamic>.from(json["businessPhones"].map((x) => x)),
    displayName: json["displayName"],
    givenName: json["givenName"],
    jobTitle: json["jobTitle"] ?? "",
    mail: json["mail"]??"",
    surname: json["surname"] ?? '',
    userPrincipalName: json["userPrincipalName"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "@odata.context": odataContext,
    "@odata.id": odataId,
    // "businessPhones": List<dynamic>.from(businessPhones.map((x) => x)),
    "displayName": displayName,
    "givenName": givenName,
    "jobTitle": jobTitle,
    "mail": mail,
    "surname": surname,
    "userPrincipalName": userPrincipalName,
    "id": id,
  };
}

RefreshModel refreshModelFromJson(String str) => RefreshModel.fromJson(json.decode(str));

String refreshModelToJson(RefreshModel data) => json.encode(data.toJson());

class RefreshModel {
  RefreshModel({
    required this.tokenType,
    required this.scope,
    required this.expiresIn,
    required this.extExpiresIn,
    required this.accessToken,
    required this.refreshToken,
    required this.idToken,
  });

  String tokenType;
  String scope;
  int expiresIn;
  int extExpiresIn;
  String accessToken;
  String refreshToken;
  String idToken;

  factory RefreshModel.fromJson(Map<String, dynamic> json) => RefreshModel(
    tokenType: json["token_type"],
    scope: json["scope"],
    expiresIn: json["expires_in"],
    extExpiresIn: json["ext_expires_in"],
    accessToken: json["access_token"],
    refreshToken: json["refresh_token"],
    idToken: json["id_token"],
  );

  Map<String, dynamic> toJson() => {
    "token_type": tokenType,
    "scope": scope,
    "expires_in": expiresIn,
    "ext_expires_in": extExpiresIn,
    "access_token": accessToken,
    "refresh_token": refreshToken,
    "id_token": idToken,
  };
}