import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alice Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Alice Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

String randomNumber() {
  var rng = Random();
  String num = rng.nextInt(100).toString();
  return num;
}

class _MyHomePageState extends State<MyHomePage> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  String resultUsername = "";
  String resultPassword = "";
  String identityAuth = "";
  String token = "";

  // int _counter = 0;

  // void login() {
  //   setState(() {
  //     resultUsername = _username.text;
  //     resultPassword = _password.text;
  //     identityAuth = "";
  //     token = "";
  //   });
  // }

  callLogin() async {
    try {
      var response = await http.post(
          Uri.parse('http://192.168.1.62:8080/Service/VerifyAuth'),
          body: {'user': _username.text, 'pass': _password.text});
      // print("value ${response.body}");
      Map<String, dynamic> result = jsonDecode(response.body);
      // Map<String, dynamic> personData = result['personData'];
      // ignore: avoid_print
      print("value ${result.toString()}");
      // print("personData1: ${personData.toString()}");
      setState(() {
        identityAuth = result['IdentityAuth'].toString();
        token = result['Token'].toString();
      });
      if (identityAuth == 'true') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const MySecondRoute(
                    title: 'Location',
                  )),
        );
      }
    } catch (err) {
      // ignore: avoid_print
      print("error ${err.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                      controller: _username,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                      )),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                      controller: _password,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      )),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 30),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Container(
                            decoration:
                                const BoxDecoration(color: Colors.lightBlue),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16.0),
                            primary: Colors.white,
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () async {
                            await callLogin();
                          },
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Container(
            //   margin: const EdgeInsets.only(bottom: 20.0),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       Text(
            //         identityAuth,
            //         style: Theme.of(context).textTheme.headline4,
            //       ),
            //     ],
            //   ),
            // ),
            // Container(
            //   margin: const EdgeInsets.only(bottom: 20.0),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       Text(
            //         token,
            //         style: Theme.of(context).textTheme.headline4,
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: login,
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

class MySecondRoute extends StatefulWidget {
  const MySecondRoute({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MySecondRoute> createState() => _MySecondRouteState();
}

class _MySecondRouteState extends State<MySecondRoute> {
  var longS = "";
  var latS = "";
  var address = "";

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

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    setState(() {
      longS = position.longitude.toString();
      latS = position.latitude.toString();
      address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second Route"),
      ),
      body: Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      longS + " : " + latS,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      address,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                    onPressed: () async {
                      Position position = await _getGeoLocationPosition();
                      GetAddressFromLatLong(position);
                    },
                    child: const Text('Get Location')),
              )
            ],
          )
          // child: ElevatedButton(
          //   onPressed: () {
          //     // Navigate back to first route when tapped.
          //   },
          //   child: const Text('Go back!'),
          // ),
          ),
    );
  }
}
