import 'package:alice/pages/main_page.dart';
import 'package:alice/provider/model_data.dart';
import 'package:provider/provider.dart';
import 'package:alice/result/user_login_result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    // final UserDemo myProvider = Provider.of<UserDemo>(context, listen: false);
    super.initState();
    // _username = TextEditingController(text: myProvider.name);
    print('init state');
  }

  final _username = TextEditingController();
  final _password = TextEditingController();

  Future<UserLoginResult> login() async {
    // final UserDemo myProvider = Provider.of<UserDemo>(context);
    var url = Uri.parse(
        'https://alice-api-service-dev.gb2bnm5p3ohuo.ap-southeast-1.cs.amazonlightsail.com/Service/VerifyAuth');
    var response = await http
        .post(url, body: {'user':_username.text, 'pass': _password.text});
    print("response ${response.body}");

    // var result = response.body;
    var result = userLoginResultFromJson(response.body);
    // setState(() {
    //   _dataFromLogin = userLoginResultFromJson(result);
    // });

    print(result);

    if (result.identityAuth == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => MainPage(loginData: result)));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('เข้าสู่ระบบไม่สำเร็จ'),
              content: Text('Username หรือ Password ไม่ถูกต้อง'),
            );
          });
    }

    return result;
  }

  @override
  void dispose() {
    _username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Alice Login'),
          backgroundColor: Color(0xff9ed8c1),
        ),
        body: Consumer(builder: (context, UserDemo provider, Widget child) {
          return Form(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                    controller: _username,
                    onChanged: provider.setUsername,
                    autofocus: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Username')),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                    controller: _password,
                    onChanged: provider.setPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Password')),
              ),
              Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                        child: Text('Login'),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xff9ed8c1))),
                        onPressed: () {
                          login();
                        })),
              )
            ],
          ));
        }));
  }
}
