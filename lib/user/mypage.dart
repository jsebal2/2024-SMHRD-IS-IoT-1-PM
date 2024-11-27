import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:pm_project/Diary/Calendar.dart';
import 'package:pm_project/mainPage/MainPage.dart';
import 'package:pm_project/user/Delete.dart';
import 'package:pm_project/mainPage/Login.dart';
import 'package:pm_project/user/update.dart';

class Mypage extends StatefulWidget {
  const Mypage({super.key});
  @override
  State<Mypage> createState() => _MypageState();
}


class _MypageState extends State<Mypage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Page'),
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
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
             
             
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 // 회원정보 수정 페이지로 이동
                 ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Update();
                            })
                        );

                      },
                      child: Text('회원정보 수정',
                      style: TextStyle(fontSize: 16),
                      ),
                  ),
                 
                 // 회원 탈퇴 페이지로 이동
                 ElevatedButton(
                   onPressed: () {
                     Navigator.push(context, MaterialPageRoute(
                         builder: (context) {
                           return Delete();
                         })
                     );

                   },
                   child: Text('회원 탈퇴',
                     style: TextStyle(fontSize: 16),
                   ),
                 ),

                 ElevatedButton(
                   onPressed: () {
                     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                         builder: (context) {
                           return Login();
                         }), (route)=>false);

                   },
                   child: Text('로그아웃',
                     style: TextStyle(fontSize: 16),
                   ),
                 ),
               ],
             ),

          ],
        ),
      ),
    );
  }
}
