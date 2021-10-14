import 'dart:async';

import 'package:alice/database/database.dart';
import 'package:alice/pages/checkin/camera/camera_review.dart';
import 'package:alice/pages/checkin/main_checkin_page.dart';
import 'package:alice/pages/checkin/widgets/contains_picture.dart';
import 'package:alice/result/user_login_result.dart';
import 'package:alice/services/connectivity.dart';
import 'package:alice/services/facenet_service.dart';
import 'package:alice/services/firebase_service.dart';
import 'package:alice/services/ml_kit_service.dart';
import 'package:camera/camera.dart';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class CheckinPage extends StatefulWidget {
  final UserLoginResult loginData;
  final String imagePath;
  const CheckinPage({Key key, this.loginData, this.imagePath})
      : super(key: key);

  @override
  _CheckinPageState createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> {
  FaceNetService _faceNetService = FaceNetService();
  MLKitService _mlKitService = MLKitService();
  DataBaseService _dataBaseService = DataBaseService();
  Timer _timer;

  CameraDescription cameraDescription;

  bool loading = false;

  String _timeString;
  var longS = "";
  var latS = "";
  var address = "";
  String network = "";
  Placemark place;
  Network ipdevice;

  @override
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
    getLocation();
    _startUp();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _startUp() async {
    _setLoading(true);

    List<CameraDescription> cameras = await availableCameras();

    /// takes the front camera
    cameraDescription = cameras.firstWhere(
      (CameraDescription camera) =>
          camera.lensDirection == CameraLensDirection.front,
    );

    // start the services
    await _faceNetService.loadModel();
    await _dataBaseService.loadDB(widget.loginData.identity.username);
    _mlKitService.initialize();

    _setLoading(false);
  }

  _setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  void getLocation() async {
    Position position = await _getGeoLocationPosition();
    getAddressFromLatLong(position);
    network = await verifyNetwork();
    ipdevice = await ipNetwork();
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> getAddressFromLatLong(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude,
        localeIdentifier: "th_TH");
    // print(placemarks);
    place = placemarks[0];
    // print("place $place");
    setState(() {
      longS = position.longitude.toString();
      latS = position.latitude.toString();
      // address =
      //     '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}, ${place.postalCode}';
      address =
          '${place.name}, ${place.subLocality}, ${place.administrativeArea}, ${place.country}, ${place.postalCode}';
      place = place;
    });
  }

  Future<void> saveAddress() async {
    String photoref = await uploadToStorageThread(
        widget.imagePath, widget.loginData.identity.username);
    var response = await http.post(
        Uri.parse(
            'https://alice-api-service-dev.gb2bnm5p3ohuo.ap-southeast-1.cs.amazonlightsail.com/Service/CheckIn'),
        body: {
          'street': place.street,
          'subLocality': place.subLocality,
          'locality': place.locality,
          'administrativeArea': place.administrativeArea,
          'country': place.country,
          'postalCode': place.postalCode,
          'Token': widget.loginData.token,
          'Ref_Photo': photoref,
          'ip4': ipdevice.ip4,
          'host': ipdevice.host,
          'network': network
        });
    print('response ${response.body}');

    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    var locationResult;
    // print("loginData " + widget.loginData.token);
    if (longS == "" && latS == "") {
      locationResult = LinearProgressIndicator();
    } else {
      locationResult = Column(children: [
        // Text(longS + " : " + latS,
        //     style: TextStyle(fontSize: 20, color: Colors.black)),
        Text(address, style: TextStyle(fontSize: 14, color: Colors.black)),
      ]);
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("ALICE CHECK IN"),
          // automaticallyImplyLeading: false
        ),
        body: Column(
          children: [
            Container(
              height: 100,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xffFFFFFF)),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      _timeString,
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    locationResult
                  ],
                ),
              ),
            ),
            widget.imagePath.isNotEmpty
                ? ContainsPicture(height: 475, imagePath: widget.imagePath)
                : Container(),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                        child: Text('CHECK IN NOW'),
                        onPressed: () async {
                          if (widget.imagePath.isEmpty) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        TakePictureScreen(
                                            loginData: widget.loginData,
                                            cameraDescription:
                                                cameraDescription)));
                          } else {
                            saveAddress();

                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                  title: const Text('Success'),
                                  content: const Text('Check in success'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  MainCheckinPage(
                                                      loginData:
                                                          widget.loginData,
                                                      imagePath: ''))),
                                      child: const Text('OK'),
                                    ),
                                  ]),
                            );
                          }
                        }))),
            // Expanded(child: SizedBox()),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: SizedBox(
            //       width: double.maxFinite,
            //       child: ElevatedButton(
            //           child: Text('Logout'),
            //           onPressed: () {
            //             Navigator.pop(context);
            //           })),
            // )
          ],
        ));
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    // var formatterDate = DateFormat.yMMMMEEEEd('en_US');
    // var formatterTime = DateFormat.Hms('en_US');
    // return "${formatterDate.format(dateTime)} ${formatterTime.format(dateTime)}";

    return DateFormat('EEEE, dd MMMM yyyy HH:mm:ss', 'en_US').format(dateTime);
  }
}
