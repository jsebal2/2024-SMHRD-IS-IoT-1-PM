import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:pm_project/Diary/Calendar.dart';
import 'package:pm_project/mainPage/MainPage.dart';
import 'package:pm_project/user/Delete.dart';
import 'package:pm_project/mainPage/Login.dart';
import 'package:pm_project/user/update.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../mainPage/Pot.dart';
import 'package:pm_project/baseUrl.dart';
import 'package:dio/dio.dart';

class Mypage extends StatefulWidget {
  const Mypage({super.key});
  @override
  State<Mypage> createState() => _MypageState();
}


class _MypageState extends State<Mypage> {

  final dio =Dio();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String? _token;
  String? nickName;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadToken(); // 토큰을 로드한 후
    if (_token != null) {
      _loadNickname(); // 토큰이 유효하면 닉네임 로드
    } else {
      print('유효한 토큰이 없습니다.');
    }
  }

  Future<void> _loadToken() async {
    try {
      String? token = await secureStorage.read(key: 'authToken');
      print('토큰가져와..$token');
      setState(() {
        _token = token;
      });
    } catch (e) {
      setState(() {
        _token = '토큰을 가져오는 중 오류 발생 : $e';
      });
    }
  }

  void _loadNickname() async{

    final data = {'id' : "$_token"};

    // post 방식의 데이터 전달을 위한 option
    dio.options.contentType = Headers.formUrlEncodedContentType;

    Response res = await dio.post('$baseUrl/plant/isthere', data: data);

    print(res);
    if(res.statusCode == 200){
      print('dio|${res.data}');
    } else {
      print('식물이름 받아오기 error 발생');
    }

    String nickName = res.data["plant_nick"];

    print(nickName);
  }


  Future<void> logout (BuildContext context) async {
    await secureStorage.delete(key: 'authToken');

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }



  // id 및 식물 id 값 가져오기
  Future<Map<String, String>> fetchUserData() async{
    await Future.delayed(Duration(seconds: 1));
    return {'id' : '$_token', 'username' : '$nickName'};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(50.0), // 중단 - content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ // 상단 프로필
              Container(
                child: Text('\n회원님\n'
                    '안녕하세요!😀',
                  style: TextStyle(fontFamily:'카페24',fontSize: 25, fontWeight: FontWeight.bold,letterSpacing: 5),),),
              SizedBox(height: 50),



              Container(
                padding: EdgeInsets.all(20.0),
                width: MediaQuery.of(context).size.height * 0.8,
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                    color: Colors.lightGreen.shade100,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    FutureBuilder(
                      future : fetchUserData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator()); // 로딩중
                        } else if (snapshot.hasError) {
                          return Text('Error : ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final data = snapshot.data!;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person),
                                  SizedBox(width: 10,),
                                  Text('나의 ID  :  ${snapshot.data!['id']}',
                                    style: TextStyle(fontSize: 18, fontFamily: '눈누토끼',letterSpacing: 3),),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                children: [
                                  Icon(Icons.park),
                                  SizedBox(width: 10,),
                                  Text('나의 식물 ID  :  ${snapshot.data!['username']}',
                                      style: TextStyle(fontSize: 18, fontFamily: '눈누토끼',letterSpacing: 3)),
                                ],
                              ),
                              SizedBox(height: 30,),
                              Center(
                                child: ElevatedButton(
                                    onPressed: (){
                                      showModalBottomSheet(context: context,
                                          builder: (BuildContext context) {
                                        return AddPot();
                                      });
                                      }, child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.add, color: Colors.white,size: 30,),
                                            SizedBox(width: 10,),
                                            Text('반려식물 추가하기',style: TextStyle(fontFamily: '눈누토끼',fontSize: 18,color: Colors.white),),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green.shade500,
                                        padding: EdgeInsets.all(10),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(80)
                                        )
                                    )
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Text('데이터를 가져오지 못했습니다.');
                        }
                      },
                    ),
                  ],),),

              SizedBox(height: 70,),
              Divider(thickness: 0.5, height: 1, color: Colors.green.shade700,),
              SizedBox(height: 20,),
              // 💡 하단 버튼 (회원정보 수정, 회원탈퇴, 로그아웃)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              ),

              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) {return Update();}));},
                title: Text('회원정보 수정', style: TextStyle(fontSize: 16,color: Colors.blueAccent.shade700),),
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
              ),

              SizedBox(height: 100,),
              // 회원 탈퇴 페이지로 이동
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) {return Delete();}));},

                title: Text('회원 탈퇴', style: TextStyle(fontSize: 13,color: Colors.grey.shade600 ),),
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
              ),



              // 로그아웃
              ListTile(
                onTap: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (context) {return Login();}), (route)=>false);},
                title: Text('로그아웃', style: TextStyle(fontSize: 13,color: Colors.grey.shade700),),
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}