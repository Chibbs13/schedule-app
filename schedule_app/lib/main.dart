import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'theme/app_theme.dart'; // make sure this file exists

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Scheduler',
      theme: AppTheme.lightTheme, // this is your custom theme
      home: const HomeScreen(),
    );
  }
}
