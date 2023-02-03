import 'package:flutter/material.dart';

final appThemeMode = ValueNotifier<ThemeMode>(ThemeMode.system);

ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.black,
    brightness: Brightness.light,
  ),
  textTheme: _textTheme,
);

ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blueGrey,
    brightness: Brightness.dark,
  ),
  textTheme: _textTheme,
);

TextTheme _textTheme = const TextTheme(
  labelLarge: TextStyle(fontSize: 21),
);
