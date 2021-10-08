import 'package:alice/pages/home_page.dart';
import 'package:alice/user_login_result.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  final UserLoginResult loginData;

  const MainPage({Key key, this.loginData}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: TabBarView(
            children: [
              HomePage(loginData: widget.loginData),
              Container(
                color: Colors.green,
              ),
            ],
          ),
          backgroundColor: Colors.blue,
          bottomNavigationBar: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home),
                text: 'Home Page',
              ),
              Tab(
                icon: Icon(Icons.warning_amber_rounded),
                text: 'Coming Soon',
              ),
            ],
          ),
        ));
  }
}
