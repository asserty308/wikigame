import 'package:flutter/material.dart';
import 'package:wikigame/widgets/game_handler.dart';

class StartNewGameWidget extends StatelessWidget {
  final GameHandlerWidgetState gameHandler;

  StartNewGameWidget(this.gameHandler) : super();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: startNewGame,
        child: Text("Spiel starten", style: TextStyle(color: Colors.white),),
        color: Colors.blue,
      ),
    );
  }

  void startNewGame() {
    this.gameHandler.startGame();
  }
}