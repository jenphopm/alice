import 'package:alice/result/checkin_history_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  List<Response> getCheckinHisList() {
    return checkinHisList;
  }

  setCheckinHisList(Response checkinHisRes) {
    checkinHisList.add(checkinHisRes);
    notifyListeners();
  }
}
