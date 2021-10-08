import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;

class MyCheckInRoute extends StatefulWidget {
  const MyCheckInRoute({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<MyCheckInRoute> createState() => _MyCheckInRouteState();
}

class _MyCheckInRouteState extends State<MyCheckInRoute> {
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
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}, ${place.postalCode}';
    });

    var response = await http
        .post(Uri.parse('http://192.168.1.62:8080/Service/CheckIn'), body: {
      'street': place.street,
      'subLocality': place.subLocality,
      'locality': place.locality,
      'administrativeArea': place.administrativeArea,
      'country': place.country,
      'postalCode': place.postalCode
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check In"),
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
                    child: const Text('Check In')),
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
