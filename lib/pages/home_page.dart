import 'package:alice/menu_box.dart';
import 'package:alice/pages/admin/home_page.dart';
import 'package:alice/pages/login_page.dart';
import 'package:alice/result/menu_result.dart';
import 'package:alice/result/user_login_result.dart';
import 'package:alice/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:alice/database/database.dart';

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

  String urlphoto;
  bool addFace = false;

  DataBaseService _dataBaseService = DataBaseService();
  Future<void> getPhoto() async {
    urlphoto = await loadToStorageThread(widget.loginData.identity.username);
  }

  Future<MenuResult> getMenuData() async {
    print('get menu data');
    addFace = await _dataBaseService.checkDataFaceDetect(widget.loginData.identity.username);
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
                child: FutureBuilder(
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 100,
                                child: Image.network(
                                  urlphoto,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: ListView(
                                padding: const EdgeInsets.all(25.0),
                                children: [
                                  SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Employee ID : ' +
                                          '${widget.loginData.identity.empId}'),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Name : ' +
                                          '${widget.loginData.identity.firstName} ${widget.loginData.identity.lastName}'),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Company : ' +
                                          '${widget.loginData.identity.company}'),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                        // children: [
                        //   Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: SizedBox(
                        //       width: 100,
                        //       child: Image.network(
                        //         urlphoto,
                        //         height: 100,
                        //         width: 100,
                        //         fit: BoxFit.fitWidth,
                        //       ),
                        //     ),
                        //   ),
                        //   SizedBox(
                        //     height: 20,
                        //     child: Container(
                        //       width: 285,
                        //       color: Colors.blue,
                        //       height: 100,
                        //     ),
                        //     // child: Text(
                        //     //     '${widget.loginData.identity.empId}  ${widget.loginData.identity.firstName}  ${widget.loginData.identity.lastName}'),
                        //     // width: 200,
                        //   ),
                        // ],
                      );
                    }
                    return LinearProgressIndicator();
                  },
                  future: getPhoto(),
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
                        if (listCodeMenu.contains("CHECKIN") == true && addFace)
                          MenuBox(
                              name: "Check in",
                              icon: Icons.access_time_outlined,
                              function: MainCheckinPage(
                                  loginData: widget.loginData, imagePath: '')),
                        if (listCodeMenu.contains("LEAVE") == true)
                          MenuBox(
                              name: "Leave",
                              icon: Icons.calendar_today,
                              function: MainCheckinPage(
                                  loginData: widget.loginData, imagePath: '')),
                        if (listCodeMenu.contains("PAYSLIP") == true)
                          MenuBox(
                              name: "PaySlip",
                              icon: Icons.money,
                              function: MainCheckinPage(
                                  loginData: widget.loginData, imagePath: '')),
                        if (listCodeMenu.contains(widget.loginData.identity.username) == true && !addFace)
                          MenuBox(
                              name: "Scan",
                              icon: Icons.face,
                              function: AdminPage()),
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
