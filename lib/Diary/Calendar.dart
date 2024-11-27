import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pm_project/mainPage/MainPage.dart';
import 'package:pm_project/mainPage/Login.dart';
import 'package:pm_project/user/mypage.dart';
import 'Custom_text.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:dio/dio.dart';

class Calendar extends StatefulWidget {
  Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

// 💡 하단 메뉴바
class _CalendarState extends State<Calendar> {


  // 하단 네비게이션 바 관련 상태 관리
  int _selectedIndex = 0;
  // 각 페이지 이동
  final List<Widget> _widgetOptions = <Widget>[
    CalendarPage(),
    Mainpage(),
    Mypage(),
  ];
  // 탭 클릭 시 페이지 이동
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex], // 선택된 페이지 표시
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_day),
            label: 'Diary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Page',
          ),
        ],
        currentIndex: _selectedIndex, // 현재 선택된 탭 인덱스
        selectedItemColor: Colors.teal,
        onTap: _onItemTapped, // 탭 클릭 시 호출
      ),
    );
  }
}


// 💡 캘린더 내용
class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}
class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final Map<DateTime, List<String>> _diaryevent = {};

  // 선택한 날짜 일기내용 출력하기
  void send_id() async{
    final dio = Dio();
    // post 방식의 데이터 전달을 위한 option
    dio.options.contentType = Headers.formUrlEncodedContentType;
    Response res = await dio.post('http://192.168.219.61:8000/diary/load',
        data: {'id' : 'test1', 'date' : '$_selectedDay'});
    // 전송결과 출력
    print(res);
    if(res.statusCode == 200){
      print('dio|${res}');
    } else {
      print('error 발생');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Plant'),
        centerTitle: true,
      ),

      // 일기 내용 추가 버튼
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            builder: (BuildContext context) {
              return Column(
                children: [
                  Flexible(
                    flex: 8,
                    child: CustomText(selectedDay:_selectedDay),
                  ),],);},);},
        child: Icon(Icons.add),
      ),


      // 캘린더 날짜 선택
      body: Column(
        children: [
          TableCalendar(
            locale: 'en_US', // 언어선택
            rowHeight: 40, // 행의 높이
            focusedDay: _focusedDay,
            firstDay: DateTime(2010, 1, 1),
            lastDay: DateTime(2040, 12, 31),
            availableGestures: AvailableGestures.all,

            // 날짜선택
            // 선택된 날짜 확인, 선택된 날짜 하이라이트 표시
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },

            // 캘린더 디자인
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.lightGreen,
                  width: 1.5,
                ),
              ),
              weekendTextStyle: TextStyle(color: Colors.red),
              selectedTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
           // 캘린더 header 디자인
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextFormatter: (date, locale) =>
                  DateFormat.yMMM(locale).format(date),
              titleTextStyle: TextStyle(fontSize: 15.0),
              headerPadding: const EdgeInsets.symmetric(vertical: 3.0),
              leftChevronIcon: const Icon(Icons.arrow_left, size: 30.0),
              rightChevronIcon: const Icon(Icons.arrow_right, size: 30.0),
            ),
          ),
        ],
      ),
    );
  }
}
