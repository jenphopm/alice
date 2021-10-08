import 'package:alice/pages/login_page.dart';
import 'package:alice/user_login_result.dart';
import 'package:flutter/material.dart';

import 'checkin/main_checkin_page.dart';

class HomePage extends StatefulWidget {
  final UserLoginResult loginData;

  const HomePage({Key key, this.loginData}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    print("loginData " + widget.loginData.token);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton(
              child: Text('Logout'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
              })
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                    child: Text('CHECK IN PAGE'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MainCheckinPage(
                                      loginData: widget.loginData)));
                    })),
          )
        ],
      ),
    );
  }
}
