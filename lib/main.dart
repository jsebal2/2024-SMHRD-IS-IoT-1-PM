import 'package:flutter/material.dart';
import 'package:pm_project/Connect/Connecting.dart';
import 'package:pm_project/Diary/Calendar.dart';
import 'MainPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Connecting(),
    );
  }
}
