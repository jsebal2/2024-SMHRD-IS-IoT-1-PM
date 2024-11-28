import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final dio = Dio();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String title = '';
  String content = '';



  // 토큰 불러오기
  Future<String?> getToken() async {
    String? token = await secureStorage.read(key: 'authToken');
    print('토큰있잖아.... => $token');
    return token;
  }

  // 토큰값 보내기
  Future<Map<String, dynamic>?> fetchDateForServer(String token,
      DateTime selectedDate) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    try {
      print('보내는 함수 내부 프린트 $token');
      final response = await dio.post('http://192.168.219.61:8000/diary/load',
          options: Options(
            headers: {
              'Content-Type': 'application/json', 'Authorization': '$token'
            },
          ),
          data: {
            'date': formattedDate,
          }
      );
      if (response.statusCode == 200) {
        print('성공 : ${response.data}');
        return response.data;
      } else {
        print('데이터 받기 실패 왜? ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error : $e');
    }
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) async {
    setState(() {
      _selectedDay = selectedDate;
      _focusedDay = focusedDate;
    });

    String? token = await getToken();
    if (token == null) {
      print('토큰이 없어');
      //await fetchDateForServer(token, selectedDate);
      return;
    }

    Map<String, dynamic>? data = await fetchDateForServer(token, selectedDate);

    if (data != null) {
      setState(() {
        title = data['title'] ?? 'No title';
        content = data['content'] ?? 'No content';
      });
    } else {
      print('No data');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('달력'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: onDaySelected,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.lightGreen,
                shape: BoxShape.circle,
              ),
              weekendTextStyle: TextStyle(color: Colors.red),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.black),
              weekendStyle: TextStyle(color: Colors.red),
            ),
          ),

          Expanded(child: Padding(padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('날짜:',
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                ),
                Text(_selectedDay != null
                  ? DateFormat('yyyy-MM-dd').format(_selectedDay!)
                  : '날짜를 선택하세요',
                style: TextStyle(fontSize: 18),),
                SizedBox(height: 20,),
                Text('제목:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  title.isNotEmpty ? title : '선택된 날짜에 제목이 없습니다.',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20,),
                Text('내용',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  content.isNotEmpty ? content : '선택된 날짜에 내용이 없습니다.',
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDiaryDialog(context),
        child: Icon(Icons.edit),
        backgroundColor: Colors.green,
      ),
    );
  }



// 다이얼로그를 통해 일기 작성
  void _showDiaryDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('일기 작성'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: '제목',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: contentController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: '내용',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // 다이얼로그 닫기
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final content = contentController.text.trim();

                if (title.isNotEmpty && content.isNotEmpty) {
                  final token = await getToken();
                  if (token != null) {
                    await saveDiary(
                        token, _selectedDay ?? _focusedDay, title, content);
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  }
                } else {
                  // 입력값 검증 실패 시 알림
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('제목과 내용을 입력해주세요!')),
                  );
                }
              },
              child: Text('저장'),
            ),
          ],
        );
      },
    );
  }

// 서버에 일기 저장
  Future<void> saveDiary(String token, DateTime selectedDate, String title,
      String content) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    try {
      final response = await dio.post(
        'http://192.168.219.61:8000/diary/save',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': '$token',
          },
        ),
        data: {
          'date': formattedDate,
          'title': title,
          'content': content,
        },
      );

      if (response.statusCode == 200) {
        print('일기 저장 성공: ${response.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('일기가 성공적으로 저장되었습니다!')),
        );
      } else {
        print('일기 저장 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('일기 저장 중 오류가 발생했습니다.')),
      );
    }
  }

}