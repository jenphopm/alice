import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatBox extends StatelessWidget {
  final String title;
  final String text;

  const StatBox({Key key, this.title, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.maxFinite,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Color(0xff9ed8c1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
