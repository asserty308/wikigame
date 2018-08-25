import 'package:flutter/material.dart';
import 'package:wikigame/widgets/start_new_game.dart';

enum GameStates {
  uninitialized,
  started,
  paused
}

class GameHandlerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GameHandlerWidgetState();
}

class GameHandlerWidgetState extends State<GameHandlerWidget> {
  var gameState = GameStates.uninitialized;

  void startGame() {
    this.setState((){
      this.gameState = GameStates.started;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Wikigame"), centerTitle: true, backgroundColor: Colors.black, elevation: 1.0,),
      body: this.getCurrentWidget(),
    );
  }

  Widget getCurrentWidget() {
    switch (this.gameState) {
      case GameStates.uninitialized: return StartNewGameWidget(this);
      case GameStates.started: return Container(color: Colors.black,);
      case GameStates.paused: return null;
      default: return null;
    }
  }
}