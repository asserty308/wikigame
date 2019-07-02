import 'package:flutter/material.dart';
import 'package:wikigame/api/wiki_article.dart';
import 'package:wikigame/widgets/gamemodes/classic_game_widget.dart';
import 'package:wikigame/widgets/gamemodes/five_to_jesus_widget.dart';
import 'package:wikigame/widgets/select_game_mode.dart';
import 'package:wikigame/widgets/start_new_game.dart';

enum GameStates {
  menu,
  stopped,
  started,
  paused
}

enum GameModes {
  classic,
  fiveToJesus,
  twoMinTimeTrial
}

class GameHandlerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GameHandlerWidgetState();
}

class GameHandlerWidgetState extends State<GameHandlerWidget> {
  var gameState = GameStates.menu;
  WikiArticle startArticle, goalArticle;
  GameModes gameMode;

  void selectClassicMode() {
    this.setState((){
      this.gameState = GameStates.stopped;
      this.gameMode = GameModes.classic;
    });
  }

  void selectFiveToJesus() {
    this.setState(() {
      this.gameState = GameStates.stopped;
      this.gameMode = GameModes.fiveToJesus;
    });
  }

  void selectTimeTrials() {
    this.setState(() {
      this.gameState = GameStates.stopped;
      this.gameMode = GameModes.twoMinTimeTrial;
    });
  }

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
      case GameStates.menu: return SelectGameMode(gameHandler: this);
      case GameStates.stopped: return StartNewGameWidget(this);
      case GameStates.started:
        {
          if (this.gameMode == GameModes.classic) {
            return ClassicGameWidget(
              startArticle: this.startArticle,
              goalArticle: this.goalArticle,
              gameHandler: this,);
          } else if (this.gameMode == GameModes.fiveToJesus) {
            return FiveToJesusWidget(
                startArticle: this.startArticle,
                gameHandler: this);
          }

          return null;
        }
      case GameStates.paused: return null;
      default: return null;
    }
  }
}