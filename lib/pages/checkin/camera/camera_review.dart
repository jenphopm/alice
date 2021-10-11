
import 'package:alice/result/user_login_result.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:alice/main.dart';

import 'display_picture.dart';

class TakePictureScreen extends StatefulWidget {
  final UserLoginResult loginData;
  const TakePictureScreen({Key key, this.loginData}) : super(key: key);

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  CameraDescription cameraDescription;
  CameraController cameraController;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
     _startUp();
  }

  _startUp() async {
    cameraDescription = cameras.firstWhere(
      (CameraDescription camera) =>
          camera.lensDirection == CameraLensDirection.front,
    );

    cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _initializeControllerFuture = cameraController.initialize();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(child:  CameraPreview(cameraController),);
           
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(

        onPressed: () async {

          try {
            await _initializeControllerFuture;

            final image = await cameraController.takePicture();

            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  loginData: widget.loginData,
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}


