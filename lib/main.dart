//import 'package:flutter/foundation.dart'
    //show debugDefaultTargetPlatformOverride;
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikigame/screens/article_details_screen.dart';
import 'package:wikigame/screens/classic_game_screen.dart';
import 'package:wikigame/screens/search/search_article_screen.dart';
import 'package:wikigame/screens/select_game_mode_screen.dart';
import 'package:wikigame/screens/settings_screen.dart';
import 'package:wikigame/tools/globals.dart';
import 'package:wikigame/widgets/five_to_jesus_widget.dart';
import 'package:wikigame/widgets/time_trial_widget.dart';

void main() async {
  // platform override necessary for flutter to recognize windows as a platform
  //debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  globalPrefs = await SharedPreferences.getInstance();

  // analytics is enabled by default
  var analyticsOn = globalPrefs.getBool('analyticsOn') ?? true;
  globalAnalytics.setAnalyticsCollectionEnabled(analyticsOn);

  // setup crashlytics
  Crashlytics.instance.enableInDevMode = false;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  // setup brightness
  var brightness = (globalPrefs.getBool('darkModeOn') ?? false) ? Brightness.dark : Brightness.light;
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
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: globalAnalytics),
      ],
    );
  }
}