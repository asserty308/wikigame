import 'package:flutter/material.dart';
import 'package:wikigame/style/text_styles.dart';

class SelectGameModeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  onTap: () { 
                    startClassicMode(context);
                  }
                ),
                ListTile(
                  title: BodyText(text: '5 Klicks bis Jesus',),
                  onTap: () {
                    startFiveToJesus(context);
                  }
                ),
                ListTile(
                  title: BodyText(text: 'Zeitdruck',),
                  onTap: () {
                    startTimeTrial(context);
                  }
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Starts the classic game mode
  void startClassicMode(BuildContext context) {
    Navigator.pushNamed(context, '/classic');
  }

  /// Starts the 5toJesus game mode
  void startFiveToJesus(BuildContext context) {
    Navigator.pushNamed(context, '/five_to_jesus');
  }

  /// Starts the time trial game mode
  void startTimeTrial(BuildContext context) {
    Navigator.pushNamed(context, '/time_trial');
  }
}