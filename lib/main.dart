import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikigame/screens/article_details_screen.dart';
import 'package:wikigame/screens/classic_game_screen.dart';
import 'package:wikigame/screens/search/search_article_screen.dart';
import 'package:wikigame/screens/select_game_mode_screen.dart';
import 'package:wikigame/screens/settings_screen.dart';
import 'package:wikigame/widgets/five_to_jesus_widget.dart';
import 'package:wikigame/widgets/time_trial_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // setup brightness
  final sharedPrefs = await SharedPreferences.getInstance();
  final brightness = (sharedPrefs.getBool('darkModeOn') ?? false) ? Brightness.dark : Brightness.light;
  runApp(MyApp(brightness: brightness));
}

class MyApp extends StatefulWidget {
  MyApp({this.brightness});
  final Brightness brightness;

  @override
  State<StatefulWidget> createState() => MyAppState(brightness: brightness);
}

class MyAppState extends State<MyApp> {
  MyAppState({this.brightness});
  Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wikigame',
      theme: ThemeData(
        brightness: brightness,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark, // always dark when system is dark
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SelectGameModeScreen(),
        '/classic': (context) => ClassicGameScreen(),
        '/five_to_jesus': (context) => FiveToJesusWidget(),
        '/time_trial': (context) => TimeTrialWidget(),
        '/article_details': (context) => ArticleScreen(),
        '/search': (context) => SearchArticleScreen(),
        '/settings': (context) => SettingsScreen(
          onThemeChanged: (isDark) { 
            setState(() {
              brightness = isDark ? Brightness.dark : Brightness.light;
            });
          },
        ),
      },
    );
  }

  void handleNotification(Map<dynamic, dynamic> message) async {
    print('received message $message');

    var data = message['data'];
    if (data != null) {
      print('message containes data $data');
    }
  }
}