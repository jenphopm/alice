import 'package:flutter/foundation.dart';

class LoginProvider with ChangeNotifier {
  Object _login;

  Object get login => _login;

  userLogin(Object loginData) {
    _login = loginData;
  }

  @override
  void notifyListeners() {

    super.notifyListeners();
  }
}
