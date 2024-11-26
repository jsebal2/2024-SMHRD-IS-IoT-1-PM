import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'Calendar.dart';

class CustomText extends StatefulWidget {
  const CustomText({super.key, required this.selectedDay});
  final DateTime selectedDay;
  @override
  State<CustomText> createState() => _CustomTextState();
}
class TextBox extends StatelessWidget {
  final String label;

  const TextBox({
    required this.label,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}

class _CustomTextState extends State<CustomText> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  Future<void> sendDiary() async {
    final dio = Dio();
    final String title = titleController.text;
    final String content = contentController.text;


    try {
      dio.options.contentType = Headers.jsonContentType;
      var SelectedDay = DateFormat("yyyy-MM-dd").format(widget.selectedDay);
      Response response = await dio.post('http://192.168.219.61:8000/diary/save',
          data:{'title':title, 'content':content,'date':SelectedDay, 'id' : 'test1'});
      print(response);
      if (response.statusCode == 200) {
        print('데이터 전송 성공: ${response.data}');
      } else {
        print('데이터 전송 실패: ${response.statusCode}');
      }
    }catch (e) {
      print('에러 발생: $e');
    }
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('  daily plant ✏',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10), // 제목라벨과 입력 필드 칸 간격

          // 🔎 text 입력 부분
          TextBox(label: '제목'),
          SizedBox(height: 10),
          //  제목 입력 칸
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '제목을 입력하세요',
                hintStyle: TextStyle(color: Colors.grey,)
            ),
          ),
          SizedBox(height: 10), // 제목 입력 칸과 내용 입력 칸 사이 간격

          TextBox(label: '내용'),
          SizedBox(height: 10),
          // 내용 입력 칸
          TextFormField(
            controller: contentController,
            maxLines: 2,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '나의 식물에 대해 알려주세요😀🍀',
                hintStyle: TextStyle(color: Colors.grey)
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: ElevatedButton(onPressed: sendDiary, child: Text('save'),),
          )
        ],
      ),
    );
  }
}