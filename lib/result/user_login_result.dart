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
  });

  bool identityAuth;
  String token;

  factory UserLoginResult.fromJson(Map<String, dynamic> json) =>
      UserLoginResult(
        identityAuth:
            json["IdentityAuth"] == null ? null : json["IdentityAuth"],
        token: json["Token"] == null ? null : json["Token"],
      );

  Map<String, dynamic> toJson() => {
        "IdentityAuth": identityAuth == null ? null : identityAuth,
        "Token": token == null ? null : token,
      };
}
