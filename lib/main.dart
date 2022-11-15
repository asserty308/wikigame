import 'package:flutter/material.dart';
import 'package:wikigame/application/config/app_dependencies.dart';
import 'package:wikigame/ui/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  registerDependencies();

  runApp(const MyApp());
}
