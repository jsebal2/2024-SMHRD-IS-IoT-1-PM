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
  final dio = Dio();
  late Timer _timer; // 타이머 선언
  Future<Map<String, dynamic>>? _sensorDataFuture;
  bool light_on_off = true;
  bool wind_on_off = true;
  bool water_on_off = true;



  // get 방식
  void getDio() async{
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

  // 센서 데이터 화면에 출력
  Future<Map<String, dynamic>> fetchSensorData() async{
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
  void initState() {
    super.initState();
    _sensorDataFuture = fetchSensorData(); // 초기 데이터 로드
    _startAutoRefresh(); // 1분마다 데이터 새로고침
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        _sensorDataFuture = fetchSensorData(); // 1분뒤 데이터 다시 가져오기
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // 타이머해제
    super.dispose();
  }

  // 조명 on/off
  void get_light_on_off(bool value) async{
    try{
      Response res = await dio.get('http://192.168.219.61:8000',
          queryParameters: {'조명' : '$light_on_off'}
      );
    }catch (e) {
      print('Error : $e');
    }
  }

  // 팬 on/off
  void get_wind_on_off(bool value) async{
    try{
      Response res = await dio.get('http://192.168.219.61:8000',
          queryParameters: {'팬' : '$light_on_off'}
      );
    }catch (e) {
      print('Error : $e');
    }
  }

  // 펌프 on/off
  void get_water_on_off(bool value) async{
    try{
      Response res = await dio.get('http://192.168.219.61:8000',
          queryParameters: {'펌프' : '$light_on_off'}
      );
    }catch (e) {
      print('Error : $e');
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
              future: _sensorDataFuture, // 비동기 데이터 요청
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
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ControlButton(icon : Icons.lightbulb, label : 'Light'),
                    Switch(value: light_on_off, onChanged: (value){
                      setState(() {
                        light_on_off = value;
                      });
                      get_light_on_off(value);
                    }
                    )
                  ],
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ControlButton(icon : Icons.air, label : 'Wind'),
                    Switch(value: wind_on_off, onChanged: (value){
                      setState(() {
                        wind_on_off = value;
                      });
                      get_wind_on_off(value);
                    })
                  ],
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ControlButton(icon : Icons.water_drop, label : 'Water'),
                    Switch(value: water_on_off, onChanged: (value){
                      setState(() {
                        water_on_off = value;
                      });
                      get_water_on_off(value);
                    })
                  ],
                ),
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
