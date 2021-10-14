import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DataBaseService {
  // singleton boilerplate
  static final DataBaseService _cameraServiceService =
      DataBaseService._internal();

  factory DataBaseService() {
    return _cameraServiceService;
  }
  // singleton boilerplate
  DataBaseService._internal();

  /// file that stores the data on filesystem
  File jsonFile;

  /// Data learned on memory
  Map<String, dynamic> _db = Map<String, dynamic>();
  Map<String, dynamic> get db => this._db;

  /// loads a simple json file.
  Future loadDB(String username) async {
    if (username == '') {
      var tempDir = await getApplicationDocumentsDirectory();
      String _embPath = tempDir.path + '/emb.json';

      jsonFile = new File(_embPath);

      if (jsonFile.existsSync()) {
        _db = json.decode(jsonFile.readAsStringSync());
      }
    } else {
      var tempDir = await loadToStorageThread(username);
      // String _embPath = tempDir.path + '/emb.json';
      var url = Uri.parse(tempDir);
      var response = await http.get(url);

      print(response.body);

      // jsonFile = new File.fromUri(url);

      // print(jsonFile);

      // // await File(_embPath).rename('data/emb.json');
      // var srt = jsonFile.readAsStringSync();

      // print(srt);

      // if (jsonFile.existsSync()) {
      _db = json.decode(response.body);
      // }
    }
  }

  Future<bool> checkDataFaceDetect(String user) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    bool result = false;
    var listResult1 = await storage.ref(user + '/').listAll();
    if(listResult1.items.length > 0){
        listResult1.items.forEach((element) { 
          if(element.fullPath == user + "/emb.json"){
            result = true;
            return result;           
          }
        });
    }
    return result; 
  }

  Future<String> loadToStorageThread(String user) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    // var test  = storage.ref().listAll();
    var reference = storage.ref().child(user + '/emb.json');
    var result = reference.getDownloadURL();
    return result;
  }

  /// [Name]: name of the new user
  /// [Data]: Face representation for Machine Learning model
  Future saveData(String user, String password, List modelData) async {
    String userAndPass = user + ':' + password;
    _db[userAndPass] = modelData;

    FirebaseStorage storage = FirebaseStorage.instance;

    // String fileName;
    // File imageFile = File(imagePath);
    jsonFile.writeAsStringSync(json.encode(_db));
    // var tempDir = await getApplicationDocumentsDirectory();
    String _embPath = user + '/emb.json';
    await storage.ref().child(_embPath).putFile(jsonFile);
    cleanDB();
    // print(_db);
    // print(json.encode(_db));
  }

  /// deletes the created users
  cleanDB() {
    this._db = Map<String, dynamic>();
    jsonFile.writeAsStringSync(json.encode({}));
  }
}
