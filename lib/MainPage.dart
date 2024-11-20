import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:async';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}




class _MainpageState extends State<Mainpage> {



  @override
  Widget build(BuildContext context) {




    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SmartPotHome(),
    );
  }
}

class SmartPotHome extends StatefulWidget {

  @override
  State<SmartPotHome> createState() => _SmartPotHomeState();
}

class _SmartPotHomeState extends State<SmartPotHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Smart Pot'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),


      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 식물 성장 단계

            Center(
              child: Column(
                children: [
                  Text(
                    'Level. 1',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),


                  SizedBox(height: 8),


                  Image.asset('assets/images/10.jpg'),
                ],
              ),
            ),


            SizedBox(height: 16),


            // 센서 데이터
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SensorDataCard(label: '온도', value: '26°C'),
                SensorDataCard(label: '습도', value: '60%'),
                SensorDataCard(label: '조도', value: '300'),
              ],
            ),


            SizedBox(height: 16),


            // 원격 제어 버튼
            ControlButtons(),
            Spacer(),


            // 하단 버튼 (CCTV로 이동)
            ElevatedButton.icon(
              onPressed: () {

                // CCTV 화면 이동 로직 추가
              },
              icon: Icon(Icons.camera_alt),
              label: Text('CCTV 보기'),
              style: ElevatedButton.styleFrom(

                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SensorDataCard extends StatelessWidget {
  final String label;
  final String value;

  const SensorDataCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class ControlButtons extends StatelessWidget {
  void postDio() async{
    final dio = Dio();
    //Response res = await dio.get('http://192.168.219.73:8000/',
    //queryParameters : {'data' : 'test res', 'send' : 'get'});

    // post 방식의 데이터 전달을 위한 option
    dio.options.contentType = Headers.formUrlEncodedContentType;
    Response res = await dio.post('http://192.168.219.61:8000/',
        data: {'data' : 'asdsad', 'send' : 'post'});

    // 전송결과 출력
    print(res);
    if(res.statusCode == 200){
      print('dio|${res}');
    } else {
      print('error 발생');
    }
    // get : 데이터 전송시 주소값에 연결해 전송 = 쿼리스트링 기법
    // post : 데아터를 전달할때 주소값에 연결하지 않고
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ControlButton(icon: Icons.lightbulb, label: 'Light'),
        ControlButton(icon: Icons.air, label: 'Wind'),
        ControlButton(icon: Icons.water_drop, label: 'Water'),
        ElevatedButton(onPressed: postDio, child: Text('버튼'))
      ],
    );
  }
}

class ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const ControlButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: (){},
          icon: Icon(icon),
          color: Colors.green,
          iconSize: 36,
        ),
        Text(label),
      ],
    );
  }
}