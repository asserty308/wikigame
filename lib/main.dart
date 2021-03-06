import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikigame/app/config/app_dependencies.dart';
import 'package:wikigame/features/ui/screens/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppDependencies.register();

  // setup brightness
  final sharedPrefs = await SharedPreferences.getInstance();
  final brightness = (sharedPrefs.getBool('darkModeOn') ?? false) ? Brightness.dark : Brightness.light;
  runApp(WikigameApp(brightness: brightness));
}
