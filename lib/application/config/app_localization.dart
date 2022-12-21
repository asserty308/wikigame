import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final appLocale = ValueNotifier<Locale>(supportedLocales.first);

const supportedLocales = [
  Locale('en'),
  Locale('de'),
];

const localizationsDelegates = [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

/// Add localizations to l10n/*.arb files and run
/// flutter gen-l10n to add them to AppLocalizations
AppLocalizations getLocalizations(BuildContext context) => AppLocalizations.of(context)!;

Locale localeResolutionCallback(Locale? deviceLocale, Iterable<Locale> supportedLocales) {
  if (deviceLocale == null) {
    return supportedLocales.first;
  }
  
  // Check if the current device locale is supported
  for (final supportedLocale in supportedLocales) {
    if (supportedLocale.languageCode == deviceLocale.languageCode) {
      return supportedLocale;
    }
  }

  // If the locale of the device is not supported, use english
  return supportedLocales.first;
}
