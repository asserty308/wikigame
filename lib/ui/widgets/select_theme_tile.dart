import 'package:flutter/material.dart';
import 'package:wikigame/application/config/app_localization.dart';
import 'package:wikigame/application/style/app_theme.dart';

class SelectThemeTile extends StatefulWidget {
  const SelectThemeTile({super.key});

  @override
  State<SelectThemeTile> createState() => _SelectThemeTileState();
}

class _SelectThemeTileState extends State<SelectThemeTile> {
  final _languages = ThemeMode.values;

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(getL10n(context).app_theme),
    trailing: _dropdownButton,
  );

  Widget get _dropdownButton => DropdownButton<ThemeMode>(
    value: appThemeMode.value,
    items: _languages
      .map((e) => DropdownMenuItem<ThemeMode>(value: e, child: Text(_mapToString(e))))
      .toList(), 
    onChanged: (selected) {
      if (selected == null) {
        return;
      }
      
      setState(() {
        appThemeMode.value = selected;
      });
    },
  );

  String _mapToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }
}
