import 'package:flutter/material.dart';
import 'package:pm_project/Connect/Connecting.dart';
import 'package:pm_project/Diary/Calendar.dart';
import 'package:pm_project/user/Join.dart';
import 'package:pm_project/mainpage/Login.dart';
import 'package:pm_project/user/mypage.dart';
import 'mainPage/MainPage.dart';

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
      home: Login(),
    );
  }
}
