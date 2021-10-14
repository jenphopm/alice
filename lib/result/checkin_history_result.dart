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
        status: json["status"],
        response: List<Response>.from(
            json["response"].map((x) => Response.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
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
    this.date,
    this.time,
    this.ip4,
    this.host,
    this.network,
  });

  String username;
  String street;
  String subLocality;
  String locality;
  String province;
  String country;
  String postalCode;
  String timeStamp;
  String date;
  String time;
  String ip4;
  String host;
  String network;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        username: json["USERNAME"],
        street: json["STREET"],
        subLocality: json["SUB_LOCALITY"],
        locality: json["LOCALITY"],
        province: json["PROVINCE"],
        country: json["COUNTRY"],
        postalCode: json["POSTAL_CODE"],
        timeStamp: json["TIME_STAMP"],
        date: json["DATE"],
        time: json["TIME"],
        ip4: json["IP4"],
        host: json["HOST"],
        network: json["NETWORK"],
      );

  Map<String, dynamic> toJson() => {
        "USERNAME": username,
        "STREET": street,
        "SUB_LOCALITY": subLocality,
        "LOCALITY": locality,
        "PROVINCE": province,
        "COUNTRY": country,
        "POSTAL_CODE": postalCode,
        "TIME_STAMP": timeStamp,
        "DATE": date,
        "TIME": time,
        "IP4": ip4,
        "HOST": host,
        "NETWORK": network,
      };
}
