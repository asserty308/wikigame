import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Should be initialized in main() before launching the app
/// main() must be async
SharedPreferences globalPrefs;

var globalAnalytics = FirebaseAnalytics();