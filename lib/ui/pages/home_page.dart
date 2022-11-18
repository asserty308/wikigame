import 'package:flutter/material.dart';
import 'package:wikigame/application/config/app_localization.dart';
import 'package:wikigame/application/router/app_router.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(child: _buttons),
  );

  Widget get _buttons => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      TextButton(
        onPressed: _onStartGamePressed, 
        child: Text(getLocalizations(context).start_game),
      ),
      TextButton(
        onPressed: _onSettingsPressed, 
        child: Text(getLocalizations(context).settings),
      ),
    ],
  );

  void _onStartGamePressed() {
    appRouter.push('/game');
  }

  void _onSettingsPressed() {
    appRouter.push('/settings');
  }
}
