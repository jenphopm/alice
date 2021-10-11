import 'package:flutter/material.dart';

class StatBox extends StatelessWidget {
  final String title;
  final String text;
  final Color backgroundColor;

  const StatBox({Key key, this.title, this.text, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.maxFinite,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: backgroundColor),
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
