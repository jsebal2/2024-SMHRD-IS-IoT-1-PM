import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pm_project/mainPage/MainPage.dart';
import 'package:pm_project/page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pm_project/baseUrl.dart';


class AddPot extends StatefulWidget {
  const AddPot({super.key});

  @override
  State<AddPot> createState() => _AddPotState();
}

class _AddPotState extends State<AddPot> {

  final dio = Dio();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nickController = TextEditingController();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String? _token;



  void _signUp() async{
    final name = _nameController.text;
    final nick = _nickController.text;


    String? token = await secureStorage.read(key: 'authToken');
    setState(() {
      _token = token;
    });

    // post 방식의 데이터 전달을 위한 option
    dio.options.contentType = Headers.formUrlEncodedContentType;
    Response res = await dio.post('$baseUrl/plant/enroll',
        data: {'name' : "$name", 'nick':'$nick', 'id':"$token"});



    // 전송결과 출력
    print(res);
    if(res.statusCode == 200){
      print('dio|${res}');

      Navigator.of(context).pop();

      showDialog(context: context,
          builder:(BuildContext context) {
        return AlertDialog(
          title: Text('등록 완료'),
          content: Text('식물 등록이 완료되었습니다.'),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text('확인'))
          ],
        );
          } );
    } else {
      print('error 발생');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '새로운 반려식물 등록하기',
              style: TextStyle(fontFamily:'눈누토끼',fontSize: 24, fontWeight: FontWeight.bold,letterSpacing: 4),
            ),
            SizedBox(height: 40),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '식물종류',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green)
                )
              ),
            ),

            SizedBox(height: 20),
            TextField(
              controller: _nickController,
              decoration: InputDecoration(
                labelText: '별칭',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                  )
              ),
            ),

            SizedBox(height: 40,),
            SizedBox(
              //width: double.infinity,
              width: 200,
              child: ElevatedButton(
                onPressed: _signUp,
                child: Text('등록하기',style: TextStyle(fontFamily: '눈누토끼',color: Colors.white,fontSize: 20),),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
            ),

            SizedBox(height: 50,),

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // 모달 닫기
              },
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
