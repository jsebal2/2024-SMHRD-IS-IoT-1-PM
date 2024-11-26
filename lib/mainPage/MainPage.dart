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

  void _showSensorDataPopup(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('센서 데이터'),
        content: _buildSensorDataContent(),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          },
              child: Text('닫기')
          )
        ],
      );
    },
    );
  }

  Widget _buildSensorDataContent() {
    return FutureBuilder<Map<String, dynamic>>(
        future: fetchSensorData(), // 센서 데이터 가져오기
        builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator()); // 로딩중
          } else if (snapshot.hasError) {
            return Text('Error : ${snapshot.error}'); // 에러처리
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
            return Text('No Data'); // 데이터 없음 처리
          }
    }
    );
  }

  Widget buildSensorDataText(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'lv.${data['level']}',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${data["date"]}일차',
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Pot'),
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              // 식물 성장 단계
              Container(
                color: Colors.grey.shade300,
                child: Center(
                  child: Column(
                    children: [

                      SizedBox(height: 8),
                      InkWell(
                        onTap: () => _showSensorDataPopup(context),
                        child: Container(
                          width: 150.0, // 원형의 크기 (지름)
                          height: 150.0,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100, // 배경색 추가
                            shape: BoxShape.circle, // 원형으로 설정
                            image: DecorationImage(
                              image: AssetImage('assets/images/10.jpg'), // 이미지 경로
                              fit: BoxFit.cover, // 이미지가 원 안에 잘 채워짐
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),

                      FutureBuilder<Map <String, dynamic>>(future: fetchSensorData(),
                          builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator(),);
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error : ${snapshot.error}'),);
                        } else if (snapshot.hasData) {
                          return  Container(
                            child: buildSensorDataText(snapshot.data!),
                          );
                        } else {
                          return Center(child: Text('No data'),);
                        }
                          }),
                      Container(height: 1.0,
                      width: 370,color: Colors.grey.shade400,)
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16),

              // 원격 제어 버튼
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ControlButton(icon: Icons.lightbulb, label: 'Light'),
                      Switch(
                        value: light_on_off,
                        onChanged: (value) {
                          setState(() {
                            light_on_off = value;
                          });
                          controlDevice('light', value);
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ControlButton(icon: Icons.air, label: 'Wind'),
                      Switch(
                        value: wind_on_off,
                        onChanged: (value) {
                          setState(() {
                            wind_on_off = value;
                          });
                          controlDevice('wind', value);
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ControlButton(icon: Icons.water_drop, label: 'Water'),
                      Switch(
                        value: water_on_off,
                        onChanged: (value) {
                          setState(() {
                            water_on_off = value;
                          });
                          controlDevice('water', value);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 18),
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


