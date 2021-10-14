import 'package:alice/provider/model_data.dart';
import 'package:alice/result/checkin_history_result.dart';
import 'package:alice/result/user_login_result.dart';
import 'package:alice/timeline_date_box.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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
    getHistoryData();
  }

  Future<CheckinHistoryResult> getHistoryData() async {
    print('get data');
    var url = Uri.parse(
        'https://alice-api-service-dev.gb2bnm5p3ohuo.ap-southeast-1.cs.amazonlightsail.com/Service/HistoryCheckIn');
    var response =
        await http.post(url, body: {'Token': widget.loginData.token});

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
        body:
            Consumer(builder: (context, CheckinHistory provider, Widget child) {
          if (provider.checkinHisList.length <= 0) {
            provider.getHistoryData(widget.loginData.token);
          }

          List dateData = [];
          provider.checkinHisList.forEach((element) {
            dateData.add(element.date);
          });
          dateData = dateData.toSet().toList();

          return ListView.builder(
            itemCount: dateData.length ?? 0,
            itemBuilder: (context, int index) {
              // Response data = provider.checkinHisList[index];
              // return Container(
              //   child: Text(data.username),
              // );
              List<Response> dataHistoryDate = [];
              provider.checkinHisList.forEach((element) => {
                    if (dateData[index] == element.date)
                      {dataHistoryDate.add(element)}
                  });
              return Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: TimelineDateBox(dateData[index], dataHistoryDate),
              );
            },
          );
        }));
  }
}


 // builder: (context, CheckinHistory provider, Widget child) =>
          //     FutureBuilder(
          //   builder: (BuildContext context,
          //       AsyncSnapshot<CheckinHistoryResult> snapshot) {
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       List<Response> dataHistory = snapshot.data.response;
          //       List dateData = [];
          //       dataHistory.forEach((element) {
          //         provider.setCheckinHisList(element);
          //         dateData.add(element.date);
          //       });
          //       dateData = dateData.toSet().toList();
          //       // List<Response> dataTimelineDate = snapshot.data.response;
          //       //         dataMenu.forEach(
          //       //             (element) => listCodeMenu.add(element.codeMenu));
          //       return Column(
          //         children: [
          //           SizedBox(
          //             height: 10,
          //           ),
          //           Expanded(
          //             child: ListView.builder(
          //               itemCount: dateData.length ?? 0,
          //               itemBuilder: (context, index) {
          //                 List<Response> dataHistoryDate = [];
          //                 dataHistory.forEach((element) => {
          //                       if (dateData[index] == element.date)
          //                         {dataHistoryDate.add(element)}
          //                     });
          //                 // return Column(
          //                 //   children: [
          //                 //     Padding(
          //                 //       padding: const EdgeInsets.all(8.0),
          //                 //       child: StatBox(
          //                 //         title: dataCheckin.timeStamp,
          //                 //         text:
          //                 //             "${dataCheckin.subLocality}, ${dataCheckin.locality}, ${dataCheckin.province}, ${dataCheckin.country}, ${dataCheckin.postalCode} ",
          //                 //       ),
          //                 //     ),
          //                 //   ],
          //                 // );
          //                 return Padding(
          //                   padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          //                   child: TimelineDateBox(
          //                       dateData[index], dataHistoryDate),
          //                 );
          //                 // return TimelineTile(
          //                 //   alignment: TimelineAlign.manual,
          //                 //   lineXY: 0.2,
          //                 //   // startChild: Text('startChild'),
          //                 //   endChild: Padding(
          //                 //     padding: const EdgeInsets.all(8.0),
          //                 //     child: StatBox(
          //                 //       title: dataCheckin.timeStamp,
          //                 //       text:
          //                 //           "${dataCheckin.subLocality}, ${dataCheckin.locality}, ${dataCheckin.province}, ${dataCheckin.country}, ${dataCheckin.postalCode} ",
          //                 //     ),
          //                 //   ),
          //                 // );
          //               },
          //             ),
          //           ),
          //         ],
          //       );
          //     }

          //     return LinearProgressIndicator();
          //   },
          //   future: getHistoryData(),
          // ),