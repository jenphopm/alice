// To parse this JSON data, do
//
//     final menuResult = menuResultFromJson(jsonString);

import 'dart:convert';

MenuResult menuResultFromJson(String str) =>
    MenuResult.fromJson(json.decode(str));

String menuResultToJson(MenuResult data) => json.encode(data.toJson());

class MenuResult {
  MenuResult({
    this.status,
    this.response,
  });

  int status;
  List<Response> response;

  factory MenuResult.fromJson(Map<String, dynamic> json) => MenuResult(
        status: json["status"] == null ? null : json["status"],
        response: json["response"] == null
            ? null
            : List<Response>.from(
                json["response"].map((x) => Response.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "response": response == null
            ? null
            : List<dynamic>.from(response.map((x) => x.toJson())),
      };
}

class Response {
  Response({
    this.id,
    this.company,
    this.codeMenu,
  });

  int id;
  String company;
  String codeMenu;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        id: json["ID"] == null ? null : json["ID"],
        company: json["COMPANY"] == null ? null : json["COMPANY"],
        codeMenu: json["CODE_MENU"] == null ? null : json["CODE_MENU"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id == null ? null : id,
        "COMPANY": company == null ? null : company,
        "CODE_MENU": codeMenu == null ? null : codeMenu,
      };
}
