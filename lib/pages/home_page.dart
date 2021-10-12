import 'package:alice/menu_box.dart';
import 'package:alice/pages/login_page.dart';
import 'package:alice/result/menu_result.dart';
import 'package:alice/result/user_login_result.dart';
import 'package:flutter/material.dart';

import 'checkin/main_checkin_page.dart';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final UserLoginResult loginData;

  const HomePage({Key key, this.loginData}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    getPhone();
    getMenuData();
  }

  Future<MenuResult> getMenuData() async {
    print('get menu data');
    var url = Uri.parse(
        'https://alice-api-service-dev.gb2bnm5p3ohuo.ap-southeast-1.cs.amazonlightsail.com/Service/GetMainMenu');
    var response =
        await http.post(url, body: {'Token': widget.loginData.token});

    print(response.body);

    var result = menuResultFromJson(response.body);

    print("result menu " + result.response.toString());

    return result;
  }

  List<String> listCodeMenu = [];

  void getPhone() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Running on ${androidInfo.model}');
  }

  @override
  Widget build(BuildContext context) {
    print("loginData " + widget.loginData.token);
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
          backgroundColor: Color(0xff9ed8c1),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  child: Text('Logout'),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginPage()));
                  }),
            )
          ],
        ),
        body: Column(
          children: [
            SizedBox(
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                    ),
                    SizedBox(
                      child: Text('รูป'),
                      width: 100,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 60,
                        ),
                        SizedBox(
                          child: Center(
                            child: Text(
                                '${widget.loginData.identity.firstName}  ${widget.loginData.identity.lastName}'),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          child: Center(
                              child:
                                  Text('(${widget.loginData.identity.empId})')),
                        )
                      ],
                    ),
                  ],
                ),
                height: 150),
            Expanded(
              child: FutureBuilder(
                builder:
                    (BuildContext context, AsyncSnapshot<MenuResult> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    List<Response> dataMenu = snapshot.data.response;
                    dataMenu.forEach(
                        (element) => listCodeMenu.add(element.codeMenu));
                    return GridView.count(
                      // crossAxisCount is the number of columns
                      crossAxisCount: 4,
                      // This creates two columns with two items in each column
                      children: [
                        // Container()
                        if (listCodeMenu.contains("Check in") == true)
                          MenuBox(
                              name: "Check in",
                              icon: Icons.access_time_outlined,
                              function: MainCheckinPage(
                                  loginData: widget.loginData, imagePath: '')),
                        if (listCodeMenu.contains("Leave") == true)
                          MenuBox(
                              name: "Leave",
                              icon: Icons.calendar_today,
                              function: MainCheckinPage(
                                  loginData: widget.loginData, imagePath: '')),
                        if (listCodeMenu.contains("PaySlip") == true)
                          MenuBox(
                              name: "PaySlip",
                              icon: Icons.money,
                              function: MainCheckinPage(
                                  loginData: widget.loginData, imagePath: '')),
                      ],
                    );
                  }

                  return LinearProgressIndicator();
                },
                future: getMenuData(),
              ),
            ),
          ],
        ));
  }
}
