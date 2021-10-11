import 'package:alice/result/checkin_history_result.dart';
import 'package:alice/stat_box.dart';
import 'package:alice/result/user_login_result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CheckinHistoryPage extends StatefulWidget {
  final UserLoginResult loginData;
  const CheckinHistoryPage({Key key, this.loginData}) : super(key: key);

  @override
  _CheckinHistoryPageState createState() => _CheckinHistoryPageState();
}

class _CheckinHistoryPageState extends State<CheckinHistoryPage> {
  @override
  void initState() {
    super.initState();

    print('init state');
    getData();
  }

  Future<CheckinHistoryResult> getData() async {
    print('get data');
    var url = Uri.parse(
        'https://alice-api-service-dev.gb2bnm5p3ohuo.ap-southeast-1.cs.amazonlightsail.com/Service/HistoryCheckIn');
    var response =
        await http.post(url, body: {'Token': widget.loginData.token});
    ;
    print(response.body);

    var result = checkinHistoryResultFromJson(response.body);

    print("result " + result.response.toString());

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CHECK IN HISTORY'),
      ),
      body: FutureBuilder(
        builder: (BuildContext context,
            AsyncSnapshot<CheckinHistoryResult> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data.response.length ?? 0,
              itemBuilder: (context, index) {
                Response dataCheckin = snapshot.data.response[index];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StatBox(
                        title: dataCheckin.timeStamp,
                        text:
                            "${dataCheckin.subLocality}, ${dataCheckin.locality}, ${dataCheckin.province}, ${dataCheckin.country}, ${dataCheckin.postalCode} ",
                      ),
                    ),
                  ],
                );
              },
            );
          }

          return LinearProgressIndicator();
        },
        future: getData(),
      ),
    );
  }
}
