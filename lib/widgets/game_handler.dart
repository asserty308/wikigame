import 'package:wikigame/screens/classic_game_screen.dart';
import 'package:wikigame/screens/select_game_mode_screen.dart';
import 'package:flutter/material.dart';
import 'package:wikigame/api/wiki_article.dart';
import 'package:wikigame/widgets/five_to_jesus_widget.dart';
import 'package:wikigame/widgets/start_new_game.dart';
import 'package:wikigame/widgets/time_trial_widget.dart';

enum GameState {
  menu,
  stopped,
  started,
  paused
}

enum GameMode {
  classic,
  fiveToJesus,
  twoMinTimeTrial
}

WikiArticle globalStartArticle, globalGoalArticle;

class GameHandlerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GameHandlerWidgetState();
}

class GameHandlerWidgetState extends State<GameHandlerWidget> {
  GameState gameState = GameState.menu;
  WikiArticle startArticle, goalArticle;
  GameMode gameMode;

  void selectClassicMode() {
    setState((){
      gameState = GameState.stopped;
      gameMode = GameMode.classic;
    });
  }

  void selectFiveToJesus() {
    setState(() {
      gameState = GameState.stopped;
      gameMode = GameMode.fiveToJesus;
    });
  }

  void selectTimeTrials() {
    setState(() {
      gameState = GameState.stopped;
      gameMode = GameMode.twoMinTimeTrial;
    });
  }

  void startGame(WikiArticle start, WikiArticle goal) {
    startArticle = start;
    goalArticle = goal;

    setState((){
      gameState = GameState.started;
    });
  }

  void stopGame() {
    setState((){
      gameState = GameState.stopped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return getCurrentWidget();
  }

  Widget getCurrentWidget() {
    switch (gameState) {
      case GameState.menu: return SelectGameModeScreen();
      case GameState.stopped: return StartNewGameWidget(this);
      case GameState.started:
        {
          if (gameMode == GameMode.classic) {
            return ClassicGameScreen();
          } else if (gameMode == GameMode.fiveToJesus) {
            return FiveToJesusWidget(
              startArticle: startArticle,
              gameHandler: this
            );
          } else if (gameMode == GameMode.twoMinTimeTrial) {
            return TimeTrialWidget(
              startArticle: startArticle,
              goalArticle: goalArticle,
              gameHandler: this,
            );
          }

          return null;
        }
      case GameState.paused: return null;
      default: return null;
    }
  }
}