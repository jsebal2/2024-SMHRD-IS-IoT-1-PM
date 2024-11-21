import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:async';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {

  // get 방식
  void getDio() async{
    final dio = Dio();
    Response res = await dio.get('http://192.168.219.61:8000',
        queryParameters: {'data' : 'DDDDDDDDDDDDDDD','send':'get'}
    );
    // 전송결과 출력
    print(res);
    if(res.statusCode == 200){
      print('dio | ${res}');
    }else{
      print('error 발생');
    }
  }
  // get 방식 끝

  // post 방식
  void postDio() async{
    final dio = Dio();
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
  }
  // post 방식 끝

  Future<Map<String, dynamic>> fetchSensorData() async{
    final dio = Dio();
    try{
      print("WWWWWWWWWWWW");
      final response = await dio.get('http://192.168.219.61:8000',
    queryParameters: {'data' : 'DDDDDDDDDDDDDDD','send':'get'}
    );
      print(response);
      if (response.statusCode == 200) {
        // Json 데이터에서 title만 리스트로 추출
        return response.data; // JSON 데이터를 맵 형태로 반환
      }else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("DDDDDDDDDDDDD");
      print("errer $e");
      throw Exception('Error : $e');
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Pot'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 식물 성장 단계
            Center(
              child: Column(
                children: [
                  Text(
                    'Level 999',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 8,),

                  Image.asset('assets/images/10.jpg'),
                ],
              ),
            ),

            SizedBox(height: 16,),

            // 센서 데이터
            FutureBuilder<Map<String, dynamic>>(
              future: fetchSensorData(), // 비동기 데이터 요청
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator()); // 로딩중
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SensorDataCard(label: '온도', value: '${data['온도']}°C'),
                      SensorDataCard(label: '습도', value: '${data['습도']}%'),
                      SensorDataCard(label: '조도', value: '${data['조도']}'),
                    ],
                  );
                } else {
                  return Text("No Data");
                }
              },
            ),

            SizedBox(height: 16,),

            // 원격 제어 버튼
            // ControlButtons(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ControlButton(icon : Icons.lightbulb, label : 'Light'),
                ControlButton(icon : Icons.air, label : 'Wind'),
                ControlButton(icon : Icons.water_drop, label : 'Water')
              ],
            ),

            SizedBox(height: 18,),

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
