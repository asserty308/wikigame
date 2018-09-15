import 'package:flutter/material.dart';
import 'package:wikigame/style/text_styles.dart';
import 'package:wikigame/widgets/game_handler.dart';

class SelectGameMode extends StatelessWidget {
  final GameHandlerWidgetState gameHandler;

  const SelectGameMode({this.gameHandler}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0.0,),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: HeaderText(text: "Spielmodus auswählen"),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: BodyText(text: "Klassisch",),
                  onTap: startClassicMode,
                ),
                ListTile(
                  title: BodyText(text: "5 Klicks bis Jesus",),
                  onTap: startFiveToJesus,
                ),
                ListTile(
                  title: BodyText(text: "Zeitdruck",),
                  onTap: startTimeTrials,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void startClassicMode() {
    this.gameHandler.selectClassicMode();
  }

  void startFiveToJesus() {
  }

  void startTimeTrials() {
  }
}