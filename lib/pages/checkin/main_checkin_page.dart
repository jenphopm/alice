import 'package:alice/pages/checkin/checkin_history_page.dart';
import 'package:alice/pages/checkin/checkin_page.dart';
import 'package:alice/pages/checkin/widgets/contains_tab_controller.dart';
import 'package:alice/result/user_login_result.dart';
import 'package:flutter/material.dart';

class MainCheckinPage extends StatefulWidget {
  final UserLoginResult loginData;
  final String imagePath;

  const MainCheckinPage({Key key, this.loginData, this.imagePath})
      : super(key: key);

  @override
  _MainCheckinPageState createState() => _MainCheckinPageState();
}

class _MainCheckinPageState extends State<MainCheckinPage> {
  @override
  Widget build(BuildContext context) {
    contains_tab_bar resultTab;

    List<Widget> wid = [
      CheckinPage(loginData: widget.loginData, imagePath: widget.imagePath),
      CheckinHistoryPage(loginData: widget.loginData)
    ];

    List<Tab> tab = [
      Tab(
        icon: Icon(Icons.access_time_outlined),
        text: 'CHECK IN',
      ),
      Tab(
        icon: Icon(Icons.history),
        text: 'HISTORY',
      )
    ];

    resultTab = contains_tab_bar.set(wid, tab, Color(0xff9ed8c1), 2);

    return contains_tab_controller(result: resultTab);
  }
}
