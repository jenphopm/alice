import 'package:alice/redux/state_user_login.dart';

UserLoginState counterReducer(UserLoginState state, dynamic action) {
  if (action.type == "UPDATE_TOKEN") {
    state.token = action.data;
    return state;
  }

  return state;
}
