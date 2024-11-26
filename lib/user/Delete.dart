import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Delete extends StatefulWidget {
  const Delete({super.key});

  @override
  State<Delete> createState() => _DeleteState();
}

class _DeleteState extends State<Delete> {

  final dio = Dio();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원탈퇴'),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 경고 메시지
            Text(
              '회원 탈퇴 시 아래 내용을 확인해주세요:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              '- 회원 탈퇴 후 모든 데이터는 복구할 수 없습니다.\n'
                  '- 탈퇴 시 저장된 정보는 삭제됩니다.\n'
                  '- 이 작업은 되돌릴 수 없습니다.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),

            // 탈퇴 확인 입력 필드
            Text(
              '회원탈퇴를 원하시면 아래 입력란에 "아이디", "비밀번호"를 입력해주세요.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            TextField(
              controller: idController,
              decoration: InputDecoration(
                labelText: '아이디',
                hintText: '"아이디"를 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: '비밀번호',
                hintText: '"비밀번호"를 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 32),

            // 회원탈퇴 버튼
            ElevatedButton(
              onPressed: () {
                final name = idController.text;
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

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('회원정보가 삭제되었습니다.')),
                );

                // mypage 이동
                Navigator.pop(context);
                
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text('회원탈퇴'),
            ),
            Spacer(),

            // 하단 안내 문구
            Text(
              '계속 서비스를 이용하시고 싶으신가요? \n'
                  '탈퇴 전 다시 한 번 생각해보세요.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}