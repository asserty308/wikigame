import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:wikigame/tools/globals.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({this.onThemeChanged});

  /// Triggered when the user changes the state of the 'dark-mode' switch
  final ValueChanged<bool> onThemeChanged;

  @override
  State<StatefulWidget> createState() => SettingsScreenState(onThemeChanged: onThemeChanged);
}

class SettingsScreenState extends State<SettingsScreen> {
  SettingsScreenState({this.onThemeChanged});
  bool darkModeOn = false;
  bool analyticsOn = true;
  String version = '';

  /// Triggered when the user changes the state of the 'dark-mode' switch
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
            title: Text('Dunkelmodus'),
            subtitle: Text('Die App erscheint in einem dunklen Design'),
            value: darkModeOn,
            onChanged: (value) => toggleDarkMode(),
            secondary: Icon(Icons.lightbulb_outline),
          ),
          SwitchListTile(
            title: Text('Analytics'),
            subtitle: Text('Übertragung von Daten zur Verbesserung der App'),
            value: analyticsOn,
            onChanged: (value) => toggleAnalytics(),
            secondary: Icon(Icons.assessment),
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
    darkModeOn = globalPrefs.getBool('darkModeOn') ?? false;
    analyticsOn = globalPrefs.getBool('analyticsOn') ?? true;

    var packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;

    setState(() { 
    });
  }

  void toggleDarkMode() {
    setState(() {
      darkModeOn = !darkModeOn; 
      globalPrefs.setBool('darkModeOn', darkModeOn);
      onThemeChanged(darkModeOn);
    });
  }

  void toggleAnalytics() {
    setState(() {
      analyticsOn = !analyticsOn;
      globalPrefs.setBool('analyticsOn', analyticsOn);
      globalAnalytics.setAnalyticsCollectionEnabled(analyticsOn);
    });
  }
}