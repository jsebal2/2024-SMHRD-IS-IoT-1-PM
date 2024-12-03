import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Update extends StatefulWidget {
  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {

  final dio = Dio();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();



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
              Text('회원정보 수정',
                  style: TextStyle(
                    fontFamily:'산토끼',
                    fontSize: 30,
                    color: Colors.teal.shade600,
                    fontWeight:FontWeight.bold,),),
                SizedBox(height: 40,),

              // 이름 입력
                Text('이름',
                  style: TextStyle(fontFamily:'카페24',fontSize: 16, fontWeight: FontWeight.bold),),
              SizedBox(height: 8),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: '이름을 입력하세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal.shade600),
                  ),),),
              SizedBox(height: 20),

              // 비밀번호 입력
              Text(
                '비밀번호',
                style: TextStyle(fontFamily:'카페24',fontSize: 16, fontWeight: FontWeight.bold),),
              SizedBox(height: 8),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: '비밀번호를 입력하세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal.shade600)
                  ),),
                obscureText: true,
              ),
              SizedBox(height: 50),

              // 저장 버튼
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // 저장 버튼 클릭 이벤트 처리
                    final name = nameController.text;
                    final password = passwordController.text;

                    void sendData() async{
                      // post 방식의 데이터 전달을 위한 option
                      dio.options.contentType = Headers.formUrlEncodedContentType;
                      Response res = await dio.post('http://192.168.219.61:8000/user/change',
                          data: {'name' : '$name', 'password' : '$password'});

                      // 전송결과 출력
                      print(res);
                      if(res.statusCode == 200){
                        print('dio|${res}');
                      } else {
                        print('error 발생');
                      }
                    }
                    sendData();

                    // 데이터를 서버로 전송하는 로직 추가
                    print('Name: $name, Password: $password');

                    // 알림창 띄우기
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('회원정보가 수정되었습니다.')),
                    );

                    // mypage 이동
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent.shade700,
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                  child: Text('저장하기', style: TextStyle(fontFamily: '머니그라피',fontSize: 20,color: Colors.white,letterSpacing: 10),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
