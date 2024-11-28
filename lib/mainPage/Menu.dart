import 'package:flutter/material.dart';
import 'package:pm_project/Diary/Calendar.dart';
import 'package:pm_project/mainPage/MainPage.dart';
import 'package:pm_project/user/mypage.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  // 💡하단 메뉴바 설정
  // 하단 네비게이션 바 관련 상태 관리
  int _selectedIndex = 1;  // 초기 페이지를 Mainpage로 설정

  // 각 페이지 이동
  static List<Widget> _pages = <Widget>[
    Calendar(),
    Mainpage(),
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
      body: _pages[_selectedIndex],

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
