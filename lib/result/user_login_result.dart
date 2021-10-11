// To parse this JSON data, do
//
//     final userLoginResult = userLoginResultFromJson(jsonString);

import 'dart:convert';

UserLoginResult userLoginResultFromJson(String str,String user) =>
    UserLoginResult.fromJson(json.decode(str), user);

String userLoginResultToJson(UserLoginResult data) =>
    json.encode(data.toJson());

class UserLoginResult {
  UserLoginResult({
    this.identityAuth,
    this.token,
    this.user
  });

  bool identityAuth;
  String token;
  String user;

  factory UserLoginResult.fromJson(Map<String, dynamic> json, String _user) =>
      UserLoginResult(
        identityAuth:
            json["IdentityAuth"] == null ? null : json["IdentityAuth"],
        token: json["Token"] == null ? null : json["Token"],
        user: _user
      );

  Map<String, dynamic> toJson() => {
        "IdentityAuth": identityAuth == null ? null : identityAuth,
        "Token": token == null ? null : token,
        "user": user
      };
}
