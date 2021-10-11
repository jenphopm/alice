import 'dart:io';

import 'package:flutter/material.dart';

class ContainsPicture extends StatelessWidget {
  ContainsPicture({this.height, this.imagePath});

  double height;
  String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 8.0),
        alignment: Alignment.center,
        height: height,
        child: Image.file(
          File(imagePath),
        ));
  }
}
