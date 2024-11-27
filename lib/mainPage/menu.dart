import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:pm_project/Diary/Calendar.dart';
import 'package:pm_project/mainPage/MainPage.dart';
import 'package:pm_project/user/mypage.dart';


class Meun extends StatefulWidget {
  const Meun({super.key});

  @override
  State<Meun> createState() => _MeunState();
}
class _MeunState extends State<Meun> {
  // 💡하단 메뉴바 설정
  // 하단 네비게이션 바 관련 상태 관리
  int _selectedIndex = 0;

  // 각 페이지 이동
  final List<Widget> _widgetOptions = <Widget>[
    Calendar(),

    Mypage(),
  ];

  // 탭 클릭 시 페이지 이동
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>
        [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_view_day), label: 'Diary'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My Page'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

