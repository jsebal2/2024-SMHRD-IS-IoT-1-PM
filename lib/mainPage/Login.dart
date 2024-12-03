import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pm_project/Diary/Calendar.dart';
import 'package:pm_project/mainPage/MainPage.dart';
import 'package:pm_project/page.dart';
import 'package:pm_project/user/Join.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final dio = Dio();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<void> login(BuildContext context) async {
    final id = _idController.text;
    final password = _passwordController.text;

    dio.options.contentType = Headers.formUrlEncodedContentType;
    Response res = await dio.post('http://192.168.219.61:8000/user/login',
        data: {'id' : '$id', 'password' : '$password'});

    // 전송결과 출력
    print(res);
    if(res.statusCode == 200){
      print('dio|${res}');
    } else {
      print('error 발생');
    }

    String token = res.data['token'];
    await secureStorage.write(key: 'authToken', value: token);

    print(await secureStorage.read(key: 'authToken'));

    // 홈 화면으로 이동
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => PageTest()));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '로그인',
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
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await login(context);
                },
                child: Text('로그인'),
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('계정이 없으신가요?'),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context){return Join();}));
                    print('회원가입 페이지로 이동');
                  },
                  child: Text('회원가입'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
