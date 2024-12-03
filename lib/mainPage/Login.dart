import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pm_project/Diary/Calendar.dart';
import 'package:pm_project/mainPage/MainPage.dart';
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

    String token = res.data['token']; // 실제로는 서버로부터 받아야 합니다.
    await secureStorage.write(key: 'authToken', value: token);

    print(await secureStorage.read(key: 'authToken'));

    // 홈 화면으로 이동
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Mainpage()));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      // appBar: AppBar(
      //   title:
      //   Text('Smart Pot', style: TextStyle(fontFamily: '산토끼', fontSize:40,color: Colors.green.shade900),),
      // ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Smart Pot', style: TextStyle(fontFamily: '산토끼', fontSize:40,color: Colors.green.shade800,fontWeight: FontWeight.bold),),
              SizedBox(height: 70),
              
              // ID 입력 필드
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: 'ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green.shade300),
                  )
                ),
              ),
              SizedBox(height: 30),

              // 비밀번호 입력 필드
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green.shade300)
                  )
                ),
              ),
              SizedBox(height: 50),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await login(context);
                  },
                  child: Text('로그인', style: TextStyle(fontFamily: '머니그라피',fontSize: 20,color: Colors.white,letterSpacing: 10 ),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),),
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
                    child: Text('회원가입', style: TextStyle(color: Colors.blueAccent.shade700),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
