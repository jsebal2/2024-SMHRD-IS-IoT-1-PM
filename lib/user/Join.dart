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
  final String baseUrl = 'http://192.168.219.73:8000';

  void _signUp() async{
    final id = _idController.text;
    final password = _passwordController.text;
    final username = _usernameController.text;



      // post 방식의 데이터 전달을 위한 option
      dio.options.contentType = Headers.formUrlEncodedContentType;
      Response res = await dio.post('$baseUrl/user/join',
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
        title: Text(''),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  child: Image.asset('assets/images/plant_icon.png',width: 70,height: 70,color: Colors.teal.shade900,)
              ),
              SizedBox(height: 15),
              Text('Welcome!',
                style: TextStyle(fontFamily:'산토끼',fontSize: 30, color:Colors.teal.shade600,fontWeight: FontWeight.bold),
              ),
              Text('Smart Pot',
                style: TextStyle(fontFamily:'산토끼',fontSize: 20, color:Colors.teal.shade600,fontWeight: FontWeight.bold),
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
                    borderSide: BorderSide(color: Colors.teal.shade600),
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
                    borderSide: BorderSide(color: Colors.teal.shade600),
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
                    borderSide: BorderSide(color: Colors.teal.shade600),
                  ))),
              SizedBox(height: 50),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _signUp,
                  child: Text('회원가입',style: TextStyle(fontFamily: '머니그라피',fontSize: 20,color: Colors.white,letterSpacing: 10 )),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent.shade700,
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}