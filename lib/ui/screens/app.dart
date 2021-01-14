import 'package:flutter/material.dart';
import 'package:wikigame/ui/screens/article_details_screen.dart';
import 'package:wikigame/ui/screens/classic_game_screen.dart';
import 'package:wikigame/ui/screens/search/search_article_screen.dart';
import 'package:wikigame/ui/screens/select_game_mode_screen.dart';
import 'package:wikigame/ui/screens/settings_screen.dart';
import 'package:wikigame/ui/widgets/five_to_jesus_widget.dart';
import 'package:wikigame/ui/widgets/time_trial_widget.dart';

class WikigameApp extends StatefulWidget {
  WikigameApp({this.brightness});
  final Brightness brightness;

  @override
  State<StatefulWidget> createState() => WikigameAppState(brightness: brightness);
}

class WikigameAppState extends State<WikigameApp> {
  WikigameAppState({
    this.brightness
  });

  Brightness brightness;

  @override
  Widget build(BuildContext context) => MaterialApp(
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