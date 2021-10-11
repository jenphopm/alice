// To parse this JSON data, do
//
//     final userLoginResult = userLoginResultFromJson(jsonString);

import 'dart:convert';

UserLoginResult userLoginResultFromJson(String str) =>
    UserLoginResult.fromJson(json.decode(str));

String userLoginResultToJson(UserLoginResult data) =>
    json.encode(data.toJson());

class UserLoginResult {
  UserLoginResult({
    this.identityAuth,
    this.token,
    this.identity,
  });

  bool identityAuth;
  String token;
  Identity identity;

  factory UserLoginResult.fromJson(Map<String, dynamic> json) =>
      UserLoginResult(
        identityAuth: json["IdentityAuth"],
        token: json["Token"],
        identity: Identity.fromJson(json["Identity"]),
      );

  Map<String, dynamic> toJson() => {
        "IdentityAuth": identityAuth,
        "Token": token,
        "Identity": identity.toJson(),
      };
}

class Identity {
  Identity({
    this.result,
    this.empId,
    this.username,
    this.firstName,
    this.lastName,
    this.company,
  });

  bool result;
  String empId;
  String username;
  String firstName;
  String lastName;
  String company;

  factory Identity.fromJson(Map<String, dynamic> json) => Identity(
        result: json["RESULT"],
        empId: json["EMP_ID"],
        username: json["USERNAME"],
        firstName: json["FIRST_NAME"],
        lastName: json["LAST_NAME"],
        company: json["COMPANY"],
      );

  Map<String, dynamic> toJson() => {
        "RESULT": result,
        "EMP_ID": empId,
        "USERNAME": username,
        "FIRST_NAME": firstName,
        "LAST_NAME": lastName,
        "COMPANY": company,
      };
}
