import 'package:flutter/material.dart';
import 'package:wikigame/api/wiki_article.dart';
import 'package:wikigame/widgets/main_game_widget.dart';
import 'package:wikigame/widgets/start_new_game.dart';

enum GameStates {
  stopped,
  started,
  paused
}

class GameHandlerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GameHandlerWidgetState();
}

class GameHandlerWidgetState extends State<GameHandlerWidget> {
  var gameState = GameStates.stopped;
  WikiArticle startArticle, goalArticle;

  void startGame(WikiArticle start, WikiArticle goal) {
    this.startArticle = start;
    this.goalArticle = goal;

    this.setState((){
      this.gameState = GameStates.started;
    });
  }

  void stopGame() {
    this.setState((){
      this.gameState = GameStates.stopped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return this.getCurrentWidget();
  }

  Widget getCurrentWidget() {
    switch (this.gameState) {
      case GameStates.stopped: return StartNewGameWidget(this);
      case GameStates.started: return MainGameWidget(startArticle: this.startArticle, goalArticle: this.goalArticle, gameHandler: this,);
      case GameStates.paused: return null;
      default: return null;
    }
  }
}