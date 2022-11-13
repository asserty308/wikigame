import 'package:flutter/material.dart';
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
        child: const Text('Start Game',),
      ),
      TextButton(
        onPressed: _onSettingsPressed, 
        child: const Text('Settings',),
      ),
    ],
  );

  void _onStartGamePressed() {
    appRouter.push('/game');
  }

  void _onSettingsPressed() {
    
  }
}
