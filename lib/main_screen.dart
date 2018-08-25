import 'package:flutter/material.dart';
import 'package:wikigame/widgets/game_handler.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return GameHandlerWidget();
  }
}