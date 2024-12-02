import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AddPot extends StatefulWidget {
  const AddPot({super.key});

  @override
  State<AddPot> createState() => _AddPotState();
}

class _AddPotState extends State<AddPot> {

  final dio = Dio();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nickController = TextEditingController();

  void _signUp() async{
    final name = _nameController.text;
    final nick = _nickController.text;

    // post 방식의 데이터 전달을 위한 option
    dio.options.contentType = Headers.formUrlEncodedContentType;
    Response res = await dio.post('http://192.168.219.61:8000/user/join',
        data: {'name' : "$name", 'nick':'$nick'});

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
        title: Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '회원가입',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'ID',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _signUp,
                child: Text('식물등록'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
