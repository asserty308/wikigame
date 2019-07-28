import 'package:flutter/material.dart';
import 'package:wikigame/style/text_styles.dart';

class SelectGameModeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Spielmodus auswählen'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: HeaderText(text: 'Klassisch',),
                  onTap: () { 
                    startClassicMode(context);
                  },
                ),
                ListTile(
                  title: HeaderText(text: '5 Klicks bis Jesus',),
                  onTap: () {
                    startFiveToJesus(context);
                  }
                ),
                ListTile(
                  title: HeaderText(text: 'Zeitdruck',),
                  onTap: () {
                    startTimeTrial(context);
                  }
                ),
                ListTile(
                  title: HeaderText(text: 'Klick Tipp',),
                  onTap: () {
                    startClickPrediction(context);
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
    //Navigator.pushNamed(context, '/five_to_jesus');
    showNotAvailableDialog(context);
  }

  /// Starts the time trial game mode
  void startTimeTrial(BuildContext context) {
    //Navigator.pushNamed(context, '/time_trial');
    showNotAvailableDialog(context);
  }

  void startClickPrediction(BuildContext context) {
    //Navigator.pushNamed(context, '/prediction');
    showNotAvailableDialog(context);
  }

  void showNotAvailableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: new Text('Hinweis'),
          content: new Text('Dieser Modus ist derzeit nicht verfügbar.'),
          actions: <Widget>[
            new FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }
}