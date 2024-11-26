import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:pm_project/Diary/Calendar.dart';
import 'package:pm_project/mainPage/MainPage.dart';
import 'package:pm_project/user/Login.dart';

class Mypage extends StatefulWidget {
  const Mypage({super.key});
  @override
  State<Mypage> createState() => _MypageState();
}


class _MypageState extends State<Mypage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // 상단 - header
        centerTitle: true,
        title:
        Text('My Page',
          style : TextStyle(
              fontSize: 23,
              color: Colors.black
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),// 중단 - content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\n회원님! 안녕하세요!😀',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
        ),
            SizedBox(height: 30,),

            // 회원탈퇴
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('회원탈퇴'),
                            content: Text('탈퇴하겠습니까?'),
                            actions: [
                              TextButton(onPressed: () {
                                Navigator.of(context).pop();
                              }, child: Text('최소'),
                              ),
                              TextButton(onPressed: (){
                                Navigator.of(context).pop();
                              }, child: Text('확인'),
                              )
                            ],
                          );
                        },
                    );
                  },
                  child: Text('회원탈퇴',
                  style: TextStyle(fontSize: 16),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
