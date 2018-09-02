import 'package:flutter/material.dart';
import 'package:wikigame/style/text_styles.dart';
import 'package:wikigame/widgets/game_handler.dart';

class SelectGameMode extends StatelessWidget {
  final GameHandlerWidgetState gameHandler;

  const SelectGameMode({this.gameHandler}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Wiki Game"), centerTitle: true, backgroundColor: Colors.black, elevation: 1.0,),
      body: ListView(
        children: <Widget>[
          HeaderText(text: "Spielmodus auswählen"),
          ListTile(
            title: BodyText(text: "Klassisch",),
            onTap: startClassicMode,
          ),
          ListTile(
            title: BodyText(text: "5 Klicks bis Jesus (in Arbeit)",),
            onTap: startFiveToJesus,
          ),
          ListTile(
            title: BodyText(text: "Zeitdruck (in Arbeit)",),
            onTap: startTimeTrials,
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