import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'Custom_text.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget{
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  // 현재 선택된 날짜를 저장하기 위한 변수
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  // 일기 데이터를 관리하기 위한 Map
  final Map<DateTime, List<String>> _diaryevent = {};

//==============================================================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 💡 일기 내용 추가 버튼 및 내용 저장 버튼
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          showModalBottomSheet( // Schedule_botton 시트 열기
            context: context,
            isDismissible: true, // 배경을 클릭했을 때 Schedule_botton 시트 닫기
            builder: (BuildContext context) {
              return Column(
                children: [
                  Flexible(
                      flex: 8,
                      child: CustomText()
                  ),
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(onPressed: ()=>{},
                      child:
                      Text('Save'),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add,),
      ),

      // 💡 캘린더 부분
      appBar: AppBar(
        title: const Text('daily Plant'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 캘린더 위젯
          TableCalendar(
            //locale: 'Ko_KR', // 언어설정
            locale: 'en_US',
            rowHeight: 40,
            focusedDay: DateTime.now(),
            // 현재 날짜 기준으로 달력보기
            firstDay: DateTime(2010, 1, 1),
            lastDay: DateTime(2040, 12, 31),
            availableGestures: AvailableGestures.all,
            // 선택한 날짜와 관련된 상태 업데이트
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            // 캘린더 style
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),

              selectedDecoration: BoxDecoration(
                //color: Colors.transparent, // 배경 투명
                shape: BoxShape.circle, // 원형 테두리
                border: Border.all(
                  color: Colors.lightGreen,
                  width: 1.5,
                ),
              ),
              weekendTextStyle: TextStyle(color: Colors.red), // 주말 텍스트 색상
              selectedTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),

            // 캘린더 header style
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,

              // 현재 날짜로 표시
              titleTextFormatter: (date, locale) =>
                  DateFormat.yMMM(locale).format(date),
              titleTextStyle: TextStyle(fontSize: 15.0,),
              headerPadding: const EdgeInsets.symmetric(vertical: 3.0),
              // 다음달 이동 화살표
              leftChevronIcon: const Icon(Icons.arrow_left, size: 30.0),
              rightChevronIcon: const Icon(Icons.arrow_right, size: 30.0),
            ),
          ),
        ],
      ),

    );
  }
}