import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:async';
import 'widget.dart';
import 'function.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  final dio = Dio();
  late Timer _timer; // 타이머 선언
  Future<Map<String, dynamic>>? _sensorDataFuture;

  @override
  void initState() {
    super.initState();
    _sensorDataFuture = fetchSensorData(); // 초기 데이터 로드
    _startAutoRefresh(); // 1분마다 데이터 새로고침
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(Duration(milliseconds: 30000), (timer) {
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

                  InkWell(
                    onTap: (){
                      print('버튼클릭');
                    },
                      child: Image.asset('assets/images/10.jpg')),
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
                      SensorDataCard(label: '온도', value: '${data['temp']}°C'),
                      SensorDataCard(label: '습도', value: '${data['humidity']}%'),
                      SensorDataCard(label: '조도', value: '${data['light']}lx'),
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