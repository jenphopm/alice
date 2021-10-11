import 'package:flutter/material.dart';

class MenuBox extends StatelessWidget {
  final String name;
  final dynamic function;
  final IconData icon;
  const MenuBox({Key key, this.name, this.function, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xff9ed8c1))),
          onPressed: () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) => function))
          },
          child: Column(
            // Replace with a Row for horizontal icon + text
            children: [
              SizedBox(
                height: 10,
              ),
              Icon(
                icon,
                color: Colors.white,
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                name,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
