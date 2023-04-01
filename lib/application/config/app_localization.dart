import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final appLocale = ValueNotifier<Locale>(AppLocalizations.supportedLocales.first);

const supportedLocales = AppLocalizations.supportedLocales;
const localizationsDelegates = AppLocalizations.localizationsDelegates;

/// Add localizations to l10n/*.arb files and run
/// flutter gen-l10n to add them to AppLocalizations
AppLocalizations getL10n(BuildContext context) => AppLocalizations.of(context)!;

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
