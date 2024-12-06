import 'package:flutter/material.dart';
import 'package:pm_project/Connect/Connecting.dart';
import 'package:pm_project/Diary/Calendar.dart';
import 'package:pm_project/mainPage/Login.dart';
import 'package:pm_project/user/Join.dart';
// import 'package:pm_project/mainpage/Login.dart';
import 'package:pm_project/user/mypage.dart';
import 'package:pm_project/main.dart';
import 'package:pm_project/mainPage/MainPage.dart';

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

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {

  int _currentIndex = 1;

  final List<Widget> _pages = [
    Calendar(), // Calendar 페이지
    Mainpage(), // Main Page 본문
    Mypage(), // MyPage 페이지
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // 현재 선택된 페이지 표시
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30)
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.lime.shade200,
          currentIndex: _currentIndex,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedLabelStyle: TextStyle(
            fontFamily: '카페24',fontSize: 15, color: Colors.brown),
          unselectedLabelStyle: TextStyle(
            fontFamily: '카페24', fontSize: 15, color: Colors.grey),
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.brown,
        
          onTap: _onTap,
          items: const [
        
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'MyPage',
            ),
          ],
        ),
      ),
    );
  }
}


