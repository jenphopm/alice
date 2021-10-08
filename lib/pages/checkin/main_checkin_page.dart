import 'package:alice/pages/checkin/checkin_history_page.dart';
import 'package:alice/pages/checkin/checkin_page.dart';
import 'package:alice/result/user_login_result.dart';
import 'package:flutter/material.dart';

class MainCheckinPage extends StatefulWidget {
  final UserLoginResult loginData;

  const MainCheckinPage({Key key, this.loginData}) : super(key: key);

  @override
  _MainCheckinPageState createState() => _MainCheckinPageState();
}

class _MainCheckinPageState extends State<MainCheckinPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: TabBarView(
            children: [
              CheckinPage(loginData: widget.loginData),
              CheckinHistoryPage(loginData: widget.loginData),
            ],
          ),
          backgroundColor: Colors.blue,
          bottomNavigationBar: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.access_time_outlined),
                text: 'CHECK IN',
              ),
              Tab(
                icon: Icon(Icons.history),
                text: 'CHECK IN HISTORY',
              ),
            ],
          ),
        ));
  }
}
