import 'dart:io';

import 'package:connectivity/connectivity.dart';

Future<String> verifyNetwork() async {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();

  ConnectivityResult result = ConnectivityResult.none;
  result = await _connectivity.checkConnectivity();

  switch (result) {
    case ConnectivityResult.wifi:
    case ConnectivityResult.mobile:
    case ConnectivityResult.none:
      _connectionStatus = result.toString();
      break;
    default:
      _connectionStatus = 'Failed to get connectivity.';
      break;
  }

  return _connectionStatus;
}

Future<Network> ipNetwork() async {
  Network result;
  var listnetwork = await NetworkInterface.list();
  listnetwork.forEach((x) async {
    print(x.name);
    var listelement = x.addresses;
    listelement.forEach((y) {
      if ('IPv4' == y.type.name) {
        result = Network.set(y.address,y.host);
      }
      // print(y.address+'|'+y.host+'|'+y.isLoopback.toString()+'|'+y.rawAddress.toString()+'|'+y.type.name);
    });
    // element.addresses
  });

  return result;
}

class Network {
  Network({this.ip4, this.host});
  String ip4;
  String host;

  factory Network.set(String ip4, String host) =>
      Network(
        ip4: ip4,
        host: host
      );
}
