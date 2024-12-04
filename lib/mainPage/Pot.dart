import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pm_project/mainPage/MainPage.dart';
import 'package:pm_project/page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class AddPot extends StatefulWidget {
  const AddPot({super.key});

  @override
  State<AddPot> createState() => _AddPotState();
}

class _AddPotState extends State<AddPot> {

  final dio = Dio();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nickController = TextEditingController();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String? _token;
  final String baseUrl = 'http://192.168.219.73:8000';



  void _signUp() async{
    final name = _nameController.text;
    final nick = _nickController.text;


    String? token = await secureStorage.read(key: 'authToken');
    setState(() {
      _token = token;
    });

    // post 방식의 데이터 전달을 위한 option
    dio.options.contentType = Headers.formUrlEncodedContentType;
    Response res = await dio.post('$baseUrl/plant/enroll',
        data: {'name' : "$name", 'nick':'$nick', 'id':"$token"});

    //홈 화면으로 이동
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => PageTest()));

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
              '식물등록',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '식물종류',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),
            TextField(
              controller: _nickController,
              decoration: InputDecoration(
                labelText: '별칭',
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
