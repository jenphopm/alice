// import 'dart:io';
import 'package:alice/database/database.dart';
import 'package:alice/pages/admin/home_page.dart';
import 'package:alice/pages/checkin/main_checkin_page.dart';
import 'package:alice/pages/models/user_model.dart';
// import 'package:alice/pages/profile.dart';
import 'package:alice/pages/widgets/app_button.dart';
import 'package:alice/result/user_login_result.dart';
import 'package:alice/services/camera_service.dart';
// import 'package:alice/services/camera_service.dart';
import 'package:alice/services/facenet_service.dart';
import 'package:flutter/material.dart';
// import 'package:alice/pages/checkin/home.dart';
// import '../../app_text_field.dart';

class AuthActionButton extends StatefulWidget {
  AuthActionButton(this._initializeControllerFuture,
      {Key key,
      @required this.onPressed,
      @required this.isLogin,
      this.reload,
      this.loginData});
  final Future _initializeControllerFuture;
  final Function onPressed;
  final bool isLogin;
  final Function reload;
  final UserLoginResult loginData;
  @override
  _AuthActionButtonState createState() => _AuthActionButtonState();
}

class _AuthActionButtonState extends State<AuthActionButton> {
  /// service injection
  final FaceNetService _faceNetService = FaceNetService();
  final CameraService _cameraService = CameraService();
  final DataBaseService _dataBaseService = DataBaseService();



  User predictedUser;

  String _predictUser() {
    String userAndPass = _faceNetService.predict();
    return userAndPass ?? null;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          // Ensure that the camera is initialized.
          await widget._initializeControllerFuture;
          // onShot event (takes the image and predict output)
          bool faceDetected = await widget.onPressed();
          var condition = 'ADD';
          if (faceDetected) {
            if (widget.isLogin) {
              var userAndPass = _predictUser();
              if (userAndPass != null) {
                condition = 'DETECT';
                this.predictedUser = User.fromDB(userAndPass);
              }
            }
            PersistentBottomSheetController bottomSheetController =
                Scaffold.of(context).showBottomSheet(
                    (context) => signSheet(context, condition));

            bottomSheetController.closed.whenComplete(() => widget.reload());
          }
        } catch (e) {
          // If an error occurs, log the error to the console.
          print(e);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xff9ed8c1),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        width: MediaQuery.of(context).size.width * 0.8,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CAPTURE',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.camera_alt, color: Colors.white)
          ],
        ),
      ),
    );
  }

  Widget matchFace(condition) {
    if (condition == 'DETECT') {
      if (widget.isLogin && predictedUser != null) {
        return Container(
          child: Text(
            'VERIFICATION MATCH',
            style: TextStyle(fontSize: 20),
          ),
        );
      } else {
        return Container(
            child: Text(
          'FACE NOT MATCH!',
          style: TextStyle(fontSize: 20),
        ));
      }
    } else {
      if (widget.isLogin && predictedUser == null) {
        return Container(
            child: Text(
          'FACE NOT MATCH!',
          style: TextStyle(fontSize: 20),
        ));
      } else {
        return Container(
          child: Text(
          '${widget.loginData.identity.username}',
          style: TextStyle(fontSize: 20),
        )
            );
      }
    }
  }

  Future _nextStep(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MainCheckinPage(
                imagePath: _cameraService.imagePath,
                loginData: widget.loginData)));
  }

  Future _signUp(context) async {
    /// gets predicted data from facenet service (user face detected)
    List predictedData = _faceNetService.predictedData;
    String user = widget.loginData.identity.username;
    String password = "x";

    /// creates a new user in the 'database'
    await _dataBaseService.saveData(user, password, predictedData);

    /// resets the face stored in the face net sevice
    this._faceNetService.setPredictedData(null);

    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => AdminPage()));
  }

  Widget matchButton(context, condition) {
    if (condition == 'DETECT') {
      if (widget.isLogin && predictedUser != null) {
        return AppButton(
          text: 'NEXT',
          onPressed: () async {
            _nextStep(context);
          },
          icon: Icon(
            Icons.navigate_next,
            color: Colors.green,
          ),
        );
      } else {
        return Container();
      }
    } else {
      if (widget.isLogin && predictedUser == null) {
        return Container();
      } else {
        return AppButton(
          text: 'ADD FACE',
          onPressed: () async {
            await _signUp(context);
          },
          icon: Icon(
            Icons.face,
            color: Colors.green,
          ),
        );
      }
    }
  }

  signSheet(context, condition) {
    if (condition == 'ADD') {
      return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            matchFace(condition),
            SizedBox(height: 10),
            Divider(),
            matchButton(context, condition)
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            matchFace(condition),
            SizedBox(height: 10),
            Divider(),
            matchButton(context, condition)
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
