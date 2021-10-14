import 'package:alice/result/checkin_history_result.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineDateBox extends StatelessWidget {
  final List<Response> dataHistoryDate;
  final String dateData;

  const TimelineDateBox(this.dateData, this.dataHistoryDate, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Color(0xff9ed8c1)),
      child: Column(
        children: [
          Align(alignment: Alignment.centerLeft, child: Text('$dateData')),
          ListView.builder(
              shrinkWrap: true,
              itemCount: dataHistoryDate.length ?? 0,
              itemBuilder: (context, index) {
                return TimelineTile(
                  isFirst: index == 0,
                  isLast: index == dataHistoryDate.length - 1,
                  beforeLineStyle:
                      LineStyle(color: Colors.white.withOpacity(0.8)),
                  indicatorStyle: IndicatorStyle(
                      width: 40,
                      height: 40,
                      // color: Colors.green,
                      indicator: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Center(
                          child: Icon(Icons.check, color: Color(0xFF5D6173)),
                        ),
                      )),
                  alignment: TimelineAlign.manual,
                  lineXY: 0.2,
                  // startChild: Text('startChild'),
                  endChild: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(dataHistoryDate[index].time),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                            '${dataHistoryDate[index].subLocality} ${dataHistoryDate[index].province}'),
                        SizedBox(
                          height: 3,
                        ),
                        Text(dataHistoryDate[index].ip4)
                      ],
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
