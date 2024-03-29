import 'package:flutter/material.dart';
import 'package:wikigame/application/config/app_localization.dart';

class SelectLanguageTile extends StatefulWidget {
  const SelectLanguageTile({super.key});

  @override
  State<SelectLanguageTile> createState() => _SelectLanguageTileState();
}

class _SelectLanguageTileState extends State<SelectLanguageTile> {
  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(getL10n(context).language),
    trailing: _dropdownButton,
  );

  Widget get _dropdownButton => DropdownButton<Locale>(
    value: appLocale.value,
    items: supportedLocales
      .map((e) => DropdownMenuItem<Locale>(value: e, child: Text(e.languageCode)))
      .toList(), 
    onChanged: (selected) {
      if (selected == null) {
        return;
      }

      setState(() {
        appLocale.value = selected;
      });
    },
  );
}
