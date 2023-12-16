import 'package:flutter/material.dart';



class MyGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: GridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        children: <Widget>[
          MyBox(Colors.red, '1'),
          MyBox(Colors.blue, '2'),
          MyBox(Colors.black, '3'),
          MyBox(Colors.brown, '4'),
          MyBox(Color(0xFF41E171), '5'),
        ],
      ),
    );
  }
}

class MyBox extends StatelessWidget {
  final Color color;
  final String text;

  MyBox(this.color, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      height: 100.0,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
    );
  }
}
