import 'package:flutter/material.dart';
import 'package:wikigame/style/text_styles.dart';
import 'package:wikigame/widgets/game_handler.dart';

class SelectGameMode extends StatelessWidget {
  const SelectGameMode({this.gameHandler}) : super();

  final GameHandlerWidgetState gameHandler;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0.0, actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
          },
        )]
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: HeaderText(text: 'Spielmodus auswählen'),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: BodyText(text: 'Klassisch',),
                  onTap: startClassicMode,
                ),
                ListTile(
                  title: BodyText(text: '5 Klicks bis Jesus',),
                  onTap: startFiveToJesus,
                ),
                ListTile(
                  title: BodyText(text: 'Zeitdruck',),
                  onTap: startTimeTrial,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Starts the classic game mode
  void startClassicMode() {
    gameHandler.selectClassicMode();
  }

  /// Starts the 5toJesus game mode
  void startFiveToJesus() {
    gameHandler.selectFiveToJesus();
  }

  /// Starts the time trial game mode
  void startTimeTrial() {
    gameHandler.selectTimeTrials();
  }
}