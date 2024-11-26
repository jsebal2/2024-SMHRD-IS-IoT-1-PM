import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Join extends StatefulWidget {
  const Join({super.key});

  @override
  State<Join> createState() => _JoinState();
}

class _JoinState extends State<Join> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final dio = Dio();

  void _signUp() async{
    final id = _idController.text;
    final password = _passwordController.text;
    final username = _usernameController.text;



      // post 방식의 데이터 전달을 위한 option
      dio.options.contentType = Headers.formUrlEncodedContentType;
      Response res = await dio.post('http://192.168.219.61:8000/user/join',
          data: {'id' : "$id", 'password' : '$password', 'username':'$username'});

      // 전송결과 출력
      print(res);
      if(res.statusCode == 200){
        print('dio|${res}');
      } else {
        print('error 발생');
      }

// post 방식 끝

    // 회원가입 로직 처리
    print('ID: $id, Password: $password, Username: $username');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
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
              controller: _idController,
              decoration: InputDecoration(
                labelText: 'ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: '사용자 이름',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _signUp,
                child: Text('회원가입'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}