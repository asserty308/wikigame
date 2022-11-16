import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final appLocale = ValueNotifier<Locale>(supportedLocales.first);

const supportedLocales = [
  Locale('en'),
  Locale('de'),
];

const localizationsDelegates = [
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];
