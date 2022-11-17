import 'package:flutter/material.dart';
import 'package:wikigame/application/config/app_config.dart';
import 'package:wikigame/application/config/app_localization.dart';
import 'package:wikigame/application/router/app_router.dart';
import 'package:wikigame/application/style/app_theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    appThemeMode.addListener(() => setState(() {}),);
    appLocale.addListener(() => setState(() {}),);
  }

  @override
  void dispose() {
    appThemeMode.dispose();
    appLocale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    routerConfig: appRouter,
    debugShowCheckedModeBanner: false,
    title: appTitle,
    themeMode: appThemeMode.value,
    theme: lightTheme,
    darkTheme: darkTheme,
    localizationsDelegates: localizationsDelegates,
    locale: appLocale.value,
    supportedLocales: supportedLocales,
  );
}
