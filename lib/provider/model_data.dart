import 'package:alice/result/checkin_history_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserDemo with ChangeNotifier {
  String username;
  String password;

  String getUsername() {
    return username;
  }

  String getPassword() {
    return password;
  }

  setUsername(String user) {
    username = user;
    notifyListeners();
  }

  setPassword(String pass) {
    password = pass;
    notifyListeners();
  }
}

class CheckinHistory with ChangeNotifier {
  List<Response> checkinHisList = [];

  getHistoryData(token) async {
    print('get data');
    var url = Uri.parse(
        'https://alice-api-service-dev.gb2bnm5p3ohuo.ap-southeast-1.cs.amazonlightsail.com/Service/HistoryCheckIn');
    var response = await http.post(url, body: {'Token': token});

    print(response.body);

    var result = checkinHistoryResultFromJson(response.body);

    print("result " + result.response.toString());
    checkinHisList = result.response;
    // return checkinHisList.length;
  }

  List<Response> getCheckinHisList() {
    return checkinHisList;
  }

  setCheckinHisList(Response checkinHisRes) {
    checkinHisList.add(checkinHisRes);
    notifyListeners();
  }
}
