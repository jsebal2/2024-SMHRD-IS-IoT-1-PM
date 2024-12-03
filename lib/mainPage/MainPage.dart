import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:async';
import 'custom_widget.dart';
import 'function.dart';
import 'package:camera/camera.dart';
import 'dart:typed_data' as typed_data;
import 'Pot.dart';



class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  final dio = Dio();
  late Timer _timer; // 타이머 선언
  Future<Map<String, dynamic>>? _sensorDataFuture;
  double lightTime = 0;
  double lightPower = 0;


  @override
  void initState() {
    super.initState();
    _sensorDataFuture = fetchSensorData(); // 초기 데이터 로드
    _startAutoRefresh(); // 1분마다 데이터 새로고침
    _checkPlantData();
  }

  void _showAddPlantDialog(BuildContext context){
    showDialog(context: context, barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              width: double.maxFinite,
              height: 400,
              child: AddPot(),
            ),
          );
        }
    );
  }

  Future<void> _checkPlantData() async {
    try {
      // Secure Storage에서 토큰 가져오기
      String? token = await secureStorage.read(key: 'authToken');

      if (token != null) {
        // 서버에 토큰 전송
        var response = await dio.post(
          'http://192.168.219.61:8000/plant/isthere',
          data: {'id': token},
        );

        // 서버에서 데이터 반환 여부에 따라 상태 변경
        setState(() {
          hasPlantData = response.data['hasPlantData'] ?? false;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          hasPlantData = false; // 토큰이 없으면 기본적으로 데이터 없음 처리
        });
      }
    } catch (e) {
      print("에러 발생: $e");
      setState(() {
        isLoading = false;
        hasPlantData = false;
      });
    }
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

  List<String> generateMessage(double temp) {
    if (temp >= 18 && temp <= 25) {
      return [
        '적정', '식물 재배에 알맞은 온도입니다.'
      ];
    } else if (temp < 18) {
      return [
        '온도가 낮습니다.', '온도를 올려주는 것이 좋습니다.'
      ];
    } else {
      return [
        '온도가 높습니다.', '온도를 낮춰주는 것이 좋습니다.'
      ];
    }
  }

  Widget buildSensorDataText(Map<String, dynamic> data) {
    final temp = data['temp'].toDouble();
    final tempMessages = generateMessage(temp);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('lv.${data['level']}',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),),
        Text('${data["date"]}일차', style: TextStyle(fontSize: 18,),),
        Container(height: 1.0, width: 370,color: Colors.grey.shade400,),
        Row(
          children: [
            Icon(Icons.device_thermostat),
            Text(tempMessages[0], style: TextStyle(fontSize: 14),),
          ],
        ),
        Text(tempMessages[1], style: TextStyle(fontSize: 14),),

      ],
    );
  }
  
  Future<void> lightTimer(double value) async {
    try {
      final respose = await dio.get('http://192.168.219.61:8000/sensor/act',
          queryParameters: {'lightTimer' : '$value'});
    }catch(e) {
      print('Error => $e');
    }
  }

  Future<void> lightControl(double value) async {
    try {
      final respose = await dio.get('http://192.168.219.61:8000/sensor/act',
          queryParameters: {'lightTimer' : '$value'});
    }catch(e) {
      print('Error => $e');
    }
  }





  @override
  Widget build(BuildContext context) {
    if(isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
      body: Center(
        child: isLoading
        ? CircularProgressIndicator()
        : hasPlantData
        ?SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            return  Column(children: [
                              buildSensorDataText(snapshot.data!),
                              Container(height: 1.0,
                                width: 370,color: Colors.grey.shade400,)

                            ],

                            );
                          } else {
                            return Center(child: Text('No data'),);
                          }
                            }),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),
                Container(height: 1.0, width: 370,color: Colors.grey.shade400,),
                SizedBox(height: 10,),
                Text('조명 지속시간', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                Text('$lightTime 시간'),
                SizedBox(height: 10,),

                Slider(value: lightTime, max : 10, min: 0, divisions: 10,
                          label: '${lightTime.toStringAsFixed(0)}',
                          onChanged: (value) {
                  setState(() {
                    lightTime = value;
                  });
                  lightTimer(value);
                          }

                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('0',style: TextStyle(fontSize: 16),),
                    Text('10',style: TextStyle(fontSize: 16),),
                  ],
                ),
                Container(height: 1.0, width: 370,color: Colors.grey.shade400,),

                SizedBox(height: 10,),
                Text('조명 밝기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                Text('$lightPower %'),
                SizedBox(height: 10,),

                Slider(value: lightPower, max : 100, min: 0, divisions: 5,
                    label: '${lightPower.toStringAsFixed(0)}',
                    onChanged: (value) {
                      setState(() {
                        lightPower = value;
                      });
                      lightControl(value);
                    }

                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('0',style: TextStyle(fontSize: 16),),
                    Text('100',style: TextStyle(fontSize: 16),),
                  ],
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ControlButton(icon: Icons.water_drop, label: 'Water Cycle'),
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
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final imageBytes = await fetchImage();
                      if (imageBytes != null) {
                        showDialog(context: context,
                            builder: (context) =>ImagePopup(imageBytes: imageBytes),);
                      } else {
                        print('사진이 없어요');
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to load image')),);
                      }
                    },
                    icon: Icon(Icons.camera_alt),
                    label: Text('CCTV 보기'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ) : ElevatedButton.icon(onPressed: (){
          _showAddPlantDialog(context);
        }, icon : Icon(Icons.add),
        label : Text('식물등록')),
      ),
    );

  }
}


