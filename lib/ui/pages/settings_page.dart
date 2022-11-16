import 'package:flutter/material.dart';
import 'package:wikigame/ui/widgets/select_language_tile.dart';
import 'package:wikigame/ui/widgets/select_theme_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: _body,
  );

  Widget get _body => ListView(
    children: const [
      SelectLanguageTile(),
      SelectThemeTile(),
    ],
  );
}
