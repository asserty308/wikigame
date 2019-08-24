import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:wikigame/widgets/articles/screens/article_details_screen.dart';
import 'package:wikigame/widgets/gamemodes/classic/classic_game_widget.dart';
import 'package:wikigame/widgets/gamemodes/five_to_jesus_widget.dart';
import 'package:wikigame/widgets/gamemodes/time_trial_widget.dart';
import 'package:wikigame/widgets/search/search_article_screen.dart';
import 'package:wikigame/widgets/select_game_mode.dart';

void main() {
  // platform override necessary for flutter to recognize windows as a platform
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wikigame',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SelectGameModeWidget(),
        '/classic': (context) => ClassicGameWidget(),
        '/five_to_jesus': (context) => FiveToJesusWidget(),
        '/time_trial': (context) => TimeTrialWidget(),
        '/article_details': (context) => ArticleScreen(),
        '/search': (context) => SearchArticleScreen(),
      }
    );
  }
}