import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pm_project/baseUrl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:pm_project/mainPage/Login.dart';

class Join extends StatefulWidget {
  const Join({super.key});

  @override
  State<Join> createState() => _JoinState();
}

class _JoinState extends State<Join> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _plantnameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  final dio = Dio();

  void _signUp() async{
    final id = _idController.text;
    final password = _passwordController.text;
    final username = _usernameController.text;
    final plantname = _plantnameController.text;
    final nickname = _nicknameController.text;
    final currentTime = DateTime.now();
    final formattedDate = "${currentTime.year}-${currentTime.month.toString().padLeft(2, '0')}-${currentTime.day.toString().padLeft(2, '0')}";

    final data = {'id' : "$id", 'password' : '$password', 'username':'$username','plantname':'$plantname','nickname':'$nickname','date':formattedDate};



      // post 방식의 데이터 전달을 위한 option
      dio.options.contentType = Headers.formUrlEncodedContentType;

      try {
        final responses = await Future.wait([
          dio.post('$baseUrl/user/join',data: data),
          dio.post('$baseUrl/plant/enroll',data: data),
        ]);

        for (var i = 0; i < responses.length; i++) {
          final res = responses[i];
          if (res.statusCode == 200) {
            print('${ i+1 } 번째 위치로 실행');
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
          } else {
            print('${ i+1 }의 위치에서 오류');
          }
        }
      }catch(e) {
        print('회원가입 오류 : $e');
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(''),
      ),


      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50.0,20,50,0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: Image.asset('assets/images/plant_icon.png',width: 70,height: 70,color: Colors.green.shade800,)
                  ),
                  SizedBox(height: 15),
                  Text('Welcome!',
                    style: TextStyle(fontFamily:'산토끼',fontSize: 30, color:Colors.green.shade800,fontWeight: FontWeight.bold),
                  ),
                  Text('Smart Pot',
                    style: TextStyle(fontFamily:'산토끼',fontSize: 20, color:Colors.green.shade800,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 60),

                  TextField(
                    controller: _idController,
                    decoration: InputDecoration(
                      labelText: 'ID',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green.shade800),
                      ))),
                  SizedBox(height: 20),

                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green.shade800),
                      ))),
                  SizedBox(height: 20),

                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: '사용자 이름',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green.shade800),
                      ))),
                  SizedBox(height: 20),

                  TextField(
                      controller: _plantnameController,
                      decoration: InputDecoration(
                          labelText: '식물의 종류',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green.shade800),
                          ))),
                  SizedBox(height: 20),

                  TextField(
                      controller: _nicknameController,
                      decoration: InputDecoration(
                          labelText: '식물의 애칭',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green.shade800),
                          ))),
                  SizedBox(height: 50),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _signUp,
                      child: Text('회원가입',style: TextStyle(fontFamily: '머니그라피',fontSize: 20,color: Colors.white,letterSpacing: 10 )),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade800,
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(

                        ),
                      ),
                    ),
                  )
                  ],
                ),
            ),
            ),
          ),
      ),
      );
  }
}