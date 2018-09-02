import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String text;

  const HeaderText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text,
      style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
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
      style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.normal),
      textAlign: TextAlign.center,
    );
  }
}