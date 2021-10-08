// To parse this JSON data, do
//
//     final checkinHistoryResult = checkinHistoryResultFromJson(jsonString);

import 'dart:convert';

CheckinHistoryResult checkinHistoryResultFromJson(String str) =>
    CheckinHistoryResult.fromJson(json.decode(str));

String checkinHistoryResultToJson(CheckinHistoryResult data) =>
    json.encode(data.toJson());

class CheckinHistoryResult {
  CheckinHistoryResult({
    this.status,
    this.response,
  });

  int status;
  List<Response> response;

  factory CheckinHistoryResult.fromJson(Map<String, dynamic> json) =>
      CheckinHistoryResult(
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
    this.username,
    this.street,
    this.subLocality,
    this.locality,
    this.province,
    this.country,
    this.postalCode,
    this.timeStamp,
  });

  String username;
  String street;
  String subLocality;
  String locality;
  String province;
  String country;
  String postalCode;
  String timeStamp;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        username: json["USERNAME"] == null ? null : json["USERNAME"],
        street: json["STREET"] == null ? null : json["STREET"],
        subLocality: json["SUB_LOCALITY"] == null ? null : json["SUB_LOCALITY"],
        locality: json["LOCALITY"] == null ? null : json["LOCALITY"],
        province: json["PROVINCE"] == null ? null : json["PROVINCE"],
        country: json["COUNTRY"] == null ? null : json["COUNTRY"],
        postalCode: json["POSTAL_CODE"] == null ? null : json["POSTAL_CODE"],
        timeStamp: json["TIME_STAMP"] == null ? null : json["TIME_STAMP"],
      );

  Map<String, dynamic> toJson() => {
        "USERNAME": username == null ? null : username,
        "STREET": street == null ? null : street,
        "SUB_LOCALITY": subLocality == null ? null : subLocality,
        "LOCALITY": locality == null ? null : locality,
        "PROVINCE": province == null ? null : province,
        "COUNTRY": country == null ? null : country,
        "POSTAL_CODE": postalCode == null ? null : postalCode,
        "TIME_STAMP": timeStamp == null ? null : timeStamp,
      };
}
