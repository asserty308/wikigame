import 'package:flutter/material.dart';
import 'package:wikigame/application/router/app_router.dart';

class SelectGameModePage extends StatelessWidget {
  const SelectGameModePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(child: _buttons,),
  );

  Widget get _buttons => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      TextButton(
        onPressed: _onClassicModePressed, 
        child: const Text('Classic Mode',),
      ),
      TextButton(
        onPressed: _onFiveToJesusPressed, 
        child: const Text('Five To Jesus',),
      ),
      TextButton(
        onPressed: _onTimeTrialPressed, 
        child: const Text('Time Trial',),
      ),
      TextButton(
        onPressed: _onClickGuessPressed, 
        child: const Text('Click Guess',),
      ),
      TextButton(
        onPressed: _onBackPressed, 
        child: const Text('Back',),
      ),
    ],
  );

  void _onClassicModePressed() {

  }

  void _onFiveToJesusPressed() {

  }

  void _onTimeTrialPressed() {

  }

  void _onClickGuessPressed() {

  }

  void _onBackPressed() {
    appRouter.pop();
  }
}
