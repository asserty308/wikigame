import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({this.onThemeChanged});

  ValueChanged<bool> onThemeChanged;

  @override
  State<StatefulWidget> createState() => SettingsScreenState(onThemeChanged: onThemeChanged);
}

class SettingsScreenState extends State<SettingsScreen> {
  SettingsScreenState({this.onThemeChanged});

  bool darkModeOn = false;
  String version = 'Version: ';
  SharedPreferences prefs;

  ValueChanged<bool> onThemeChanged;

  @override
  void initState() {
    super.initState();

    // run 'afterFirstlayout' after first build()
    WidgetsBinding.instance.addPostFrameCallback((_) => afterFirstLayout(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Einstellungen'),
      ),
      body: Column(
        children: <Widget>[
          SwitchListTile(
            title: Text('Dark Mode'),
            value: darkModeOn,
            onChanged: (value) => toggleDarkMode(),
            secondary: Icon(Icons.lightbulb_outline),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(version),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void afterFirstLayout(BuildContext context) {
    initPrefs();
  }

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    darkModeOn = prefs.getBool('darkModeOn') ?? false;

    var packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;

    setState(() { 
    });
  }

  void toggleDarkMode() async {
    setState(() {
      darkModeOn = !darkModeOn; 
      prefs.setBool('darkModeOn', darkModeOn);
      onThemeChanged(darkModeOn);
    });
  }
}