//import 'package:flutter/foundation.dart'
    //show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikigame/widgets/articles/screens/article_details_screen.dart';
import 'package:wikigame/widgets/gamemodes/classic/classic_game_widget.dart';
import 'package:wikigame/widgets/gamemodes/five_to_jesus_widget.dart';
import 'package:wikigame/widgets/gamemodes/time_trial_widget.dart';
import 'package:wikigame/widgets/search/search_article_screen.dart';
import 'package:wikigame/widgets/select_game_mode.dart';
import 'package:wikigame/widgets/settings/settings_screen.dart';

void main() async {
  // platform override necessary for flutter to recognize windows as a platform
  //debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  var prefs = await SharedPreferences.getInstance();
  Brightness brightness = (prefs.getBool('darkModeOn') ?? false) ? Brightness.dark : Brightness.light;
  runApp(MyApp(brightness: brightness));
}

class MyApp extends StatefulWidget {
  MyApp({this.brightness});
  final Brightness brightness;

  @override
  State<StatefulWidget> createState() => MyAppState(brightness: brightness);
}

class MyAppState extends State<MyApp>{
  MyAppState({this.brightness});
  Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wikigame',
      theme: ThemeData(
        brightness: brightness,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SelectGameModeWidget(),
        '/classic': (context) => ClassicGameWidget(),
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
      }
    );
  }
}