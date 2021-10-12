import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

Future<String> uploadToStorageThread(String imagePath, String user) async {
  FirebaseStorage storage = FirebaseStorage.instance;

  // String fileName;
  File imageFile = File(imagePath);

  final DateTime dateTime = DateTime.now();
  var formatter = DateFormat('ddMMyyyyhhmma');
  var fileName = formatter.format(dateTime);

  print(user + '/' + fileName + '.jpg');

  await storage.ref().child(user + '/' + fileName + '.jpg').putFile(imageFile);

  return user + '/' + fileName + '.jpg';
}

Future<String> loadToStorageThread(String user) async {
  FirebaseStorage storage = FirebaseStorage.instance;

  var reference = storage.ref().child(user + '/' + user + '.jpg');

  return reference.getDownloadURL();
}
