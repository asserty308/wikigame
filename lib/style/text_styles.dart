import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String text;

  const HeaderText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text.toUpperCase(),
      style: TextStyle(
          fontSize: 17.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'PressStart2P',
          color: Colors.deepOrangeAccent),
      textAlign: TextAlign.center,
    );
  }
}

class BodyText extends StatelessWidget {
  final String text;

  const BodyText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text,
      style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
          fontFamily: 'PressStart2P',
          color: Colors.amber),
      textAlign: TextAlign.center,
    );
  }
}

class ListText extends StatelessWidget {
  final String text;

  const ListText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text.toUpperCase(),
      style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
          fontFamily: 'PressStart2P',
          color: Colors.lime),
      textAlign: TextAlign.center,
    );
  }
}

class ExplainText extends StatelessWidget {
  final String text;

  const ExplainText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text,
      style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.normal,
          fontFamily: 'PressStart2P',
          color: Colors.lightGreenAccent),
      textAlign: TextAlign.center,
    );
  }
}