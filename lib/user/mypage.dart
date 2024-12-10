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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idCotroller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //final TextEditingController _plantnameController = TextEditingController();

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

  Future<void> update (BuildContext context) async {
    final name = _nameController.text;
    final id = _idCotroller.text;
    final password = _passwordController.text;
    //final plantname = _plantnameController.text;

    final data = {'name': '$name', 'id': '$id', 'password': '$password'};

    dio.options.contentType = Headers.formUrlEncodedContentType;

    try {
      final responses = await Future.wait([
        dio.post('$baseUrl/user/change', data: data),
        //dio.post('$baseUrl/plant/change', data: data),
      ]);

      for (var i = 0; i < responses.length; i++) {
        final res = responses[i];
        if (res.statusCode == 200) {
          print('${ i + 1 } 번째 위치로 실행');
          String token = "$id";
          await secureStorage.write(key: 'authToken', value: token);
          showDialog(context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text('회원정보가 수정되었습니다.'),
                  actions: [
                    ElevatedButton(onPressed: () {
                      Navigator.of(context).pop();
                    },
                        child: Text('닫기'))
                  ],
                );
              });
        } else {
          print('${ i + 1 }의 위치에서 오류');
        }
      }
    } catch (e) {
      print('회원정보수정 오류 : $e');
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
      setState(() {
        nickName = res.data["select"]["plant_nick"];
      });


      print(res.data["plant_nick"]);
    } else {
      print('식물이름 받아오기 error 발생');
    }


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
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
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
        
        
        
                Center(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(25,40,25,20),
                    width: MediaQuery.of(context).size.height*1,
                    height: 250,
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.park),
                                      SizedBox(width: 10,),
                                      Column(
                                        children: [
                                          Text('나의 식물 ID  :',
                                              style: TextStyle(fontSize: 18, fontFamily: '눈누토끼',letterSpacing: 3)),
                                          Text('${snapshot.data!['username']}',
                                              style: TextStyle(fontSize: 18, fontFamily: '눈누토끼',letterSpacing: 3)),
                                        ],
                                      ),

                                    ],
                                  ),
                                  SizedBox(height: 40,),
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
                ),
        
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

                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: 'name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green.shade300),
                      )
                  ),
                ),
                SizedBox(height: 30),

                TextField(
                  controller: _idCotroller,
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

                // TextField(
                //   controller: _plantnameController,
                //   decoration: InputDecoration(
                //       labelText: '식물의 이름',
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderSide: BorderSide(color: Colors.green.shade300),
                //       )
                //   ),
                // ),
                // SizedBox(height: 30),

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
                SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await update(context);
                    },
                    child: Text('회원정보 수정', style: TextStyle(fontFamily: '머니그라피',fontSize: 20,color: Colors.white,letterSpacing: 10 ),),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        )
                    ),
                  ),
                ),

                SizedBox(height: 50,),


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
      ),
    );
  }
}