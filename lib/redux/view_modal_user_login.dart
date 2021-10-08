import 'package:alice/redux/state_user_login.dart';

class UserLoginViewModel {
  UserLoginState state;
  Function() onUpdateToken;

  UserLoginViewModel({this.state, this.onUpdateToken});
}
