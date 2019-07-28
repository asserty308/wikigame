import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({Key key, this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.black),
      textAlign: TextAlign.center,
    );
  }
}

class BodyText extends StatelessWidget {
  const BodyText({Key key, this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.black),
      textAlign: TextAlign.center,
    );
  }
}

class ListText extends StatelessWidget {
  const ListText({Key key, this.text, this.color = Colors.black}) : super(key: key);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: Center(
        child: Text(
          text.toUpperCase(),
          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: color,),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ExplainText extends StatelessWidget {
  const ExplainText({Key key, this.text}) : super(key: key);
  
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.black),
      textAlign: TextAlign.center,
    );
  }
}