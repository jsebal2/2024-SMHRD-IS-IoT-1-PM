import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:pm_project/Diary/Calendar.dart';
import 'package:pm_project/mainPage/MainPage.dart';
import 'package:pm_project/user/Delete.dart';
import 'package:pm_project/mainPage/Login.dart';
import 'package:pm_project/user/update.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Mypage extends StatefulWidget {
  const Mypage({super.key});
  @override
  State<Mypage> createState() => _MypageState();
}


class _MypageState extends State<Mypage> {

  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<void> logout (BuildContext context) async {
    await secureStorage.delete(key: 'authToken');

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // 상단 header
        title: Text('My Page'),
        titleTextStyle: TextStyle(fontSize: 20, fontWeight:FontWeight.bold, color: Colors.black),
        centerTitle: true,
        elevation: 0.5,
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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),

            SizedBox(height: 30,),

             // 💡 하단 버튼 (회원정보 수정, 회원탈퇴, 로그아웃)
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 // 회원정보 수정 페이지로 이동
                 ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) {return Update();}));},
                      child: Text('회원정보 수정',
                      style: TextStyle(fontSize: 16),),
                  ),
                 // 회원 탈퇴 페이지로 이동
                 ElevatedButton(
                   onPressed: () {
                     Navigator.push(context, MaterialPageRoute(
                         builder: (context) {return Delete();}));},
                   child: Text('회원 탈퇴',
                     style: TextStyle(fontSize: 16),),
                 ),
                 // 로그아웃
                 ElevatedButton(
                   onPressed: () {
                     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                         builder: (context) {return Login();}), (route)=>false);},
                   child: Text('로그아웃',
                     style: TextStyle(fontSize: 16),),
                 ),

               ],
             ),

          ],
        ),
      ),
    );
  }
}
