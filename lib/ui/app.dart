import 'package:flutter/material.dart';
import 'package:wikigame/application/router/app_router.dart';
import 'package:wikigame/application/style/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    routerConfig: appRouter,
    debugShowCheckedModeBanner: false,
    title: 'Wiki Game',
    theme: lightTheme,
    darkTheme: darkTheme,
  );
}
