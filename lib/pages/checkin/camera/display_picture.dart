import 'package:alice/pages/checkin/main_checkin_page.dart';
import 'package:alice/pages/checkin/widgets/contains_picture.dart';
import 'package:alice/user_login_result.dart';
import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatelessWidget {
  final UserLoginResult loginData;
  final String imagePath;

  const DisplayPictureScreen({Key key, this.loginData, this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Display the Picture')),
        body: Column(
          children: [
            ContainsPicture(height: 650, imagePath: imagePath),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                        child: Text('PHOTO CHECK IN'),
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MainCheckinPage(
                                          imagePath: imagePath,
                                          loginData: loginData
                                          )));
                        }))),
          ],
        ));
  }
}
