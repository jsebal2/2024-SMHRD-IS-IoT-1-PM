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
  String img_url = '';



  // 토큰 불러오기
  Future<String?> getToken() async {
    String? token = await secureStorage.read(key: 'authToken');
    print('토큰있잖아.... => $token');
    return token;
  }

  // 토큰값 보내기_다이어리
  Future<Map<String, dynamic>?> fetchDateForServer(String token,
      DateTime selectedDate, String endpoint) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    try {
      print('보내는 함수 내부 프린트 $token');
      final response = await dio.post(endpoint,
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
      img_url = '';
    });

    String? token = await getToken();
    if (token == null) {
      print('토큰이 없어');
      //await fetchDateForServer(token, selectedDate);
      return;
    }

    Map<String, dynamic>? diaryData = await fetchDateForServer(
        token, selectedDate, 'http://192.168.219.73:8000/diary/load');

    Map<String, dynamic>? picData = await fetchDateForServer(
        token, selectedDate, 'http://192.168.219.73:8000/pic/pull');

    if (diaryData != null) {
      setState(() {
        title = diaryData['title'] ?? 'No title';
        content = diaryData['content'] ?? 'No content';
      });
    } else {
      print('다이어리 데이터 없음');
    }
    if (picData != null) {
      setState(() {
        img_url = picData['img_url'] ?? '';
      });
    } else {
      print('사진 데이터 없음');
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lime.shade50,
      appBar: AppBar(
        title: Text('Diary',
        style:
        TextStyle(fontFamily: '산토끼', fontSize: 30, fontWeight: FontWeight.bold,color: Colors.green.shade800),),

      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: TableCalendar(
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
                titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontFamily: '굴토끼',
                  //fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),),
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
          ),

          
          // 선택된 날짜와 정보 표시
          Expanded(
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('선택된 날짜',
                                  style: TextStyle(fontFamily:'눈누토끼',fontSize: 18,fontWeight: FontWeight.bold,letterSpacing: 2),
                                ),
                                Text(_selectedDay != null
                                    ? DateFormat('yyyy-MM-dd').format(_selectedDay!)
                                    : '날짜를 선택하세요',
                                  style: TextStyle(fontFamily:'눈누토끼', fontSize: 18, letterSpacing: 2),),
                                SizedBox(height: 20,),

                                Text('제목',
                                  style: TextStyle(fontFamily:'눈누토끼', fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
                                ),
                                Text(title.isNotEmpty ? title : '',
                                  style: TextStyle(fontFamily:'눈누토끼',fontSize: 18, letterSpacing: 2 ),
                                ),
                                SizedBox(height: 20,),
                              ],
                            ),

                            Container(
                              child: Visibility(
                                visible: img_url.isNotEmpty, // 조건에 따라 표시 여부 결정
                                replacement: Text(
                                  '이미지가 없습니다.',
                                  style: TextStyle(fontSize: 16, color: Colors.grey),
                                ), // visible이 false일 때 대체할 위젯
                                child: Container(
                                  child: Image.network(img_url,
                                    width: 200, height: 200, fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),




                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('내용',
                              style: TextStyle(fontFamily:'눈누토끼',fontSize: 18, fontWeight: FontWeight.bold,letterSpacing: 2),
                            ),
                            Text(content.isNotEmpty ? content : '',
                              style: TextStyle(fontFamily:'눈누토끼',fontSize: 18,letterSpacing: 2),
                            )
                          ],
                        ),

                      ],
                    ),


                  ],
                ),))],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDiaryDialog(context),
        child: Icon(Icons.edit),
        backgroundColor: Colors.green.shade400,
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
        'http://192.168.219.73:8000/diary/save',
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