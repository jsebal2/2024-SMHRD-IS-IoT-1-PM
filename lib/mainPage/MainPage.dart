import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'custom_widget.dart';
import 'function.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pm_project/baseUrl.dart';

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
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String _imageUrl = 'assets/images/1level/normal_normal_normal.png';
  int _level = 1;
  String _temperatureStatus = 'normal';
  String _waterStatus = 'normal';
  String _diseaseStatus = 'normal';

  @override
  void initState() {
    super.initState();
    _sensorDataFuture = fetchSensorData(); // 초기 데이터 로드
    _startAutoRefresh(); // 1분마다 데이터 새로고침
    _checkPlantData();
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(Duration(milliseconds: 10000), (timer) {
      _fetchSensorDataAndSetImage();
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // 타이머 해제
    super.dispose();
  }

  Future<void> _checkPlantData() async {
    try {
      // Secure Storage에서 토큰 가져오기
      String? token = await secureStorage.read(key: 'token');

      if (token != null) {
        // 서버에 토큰 전송
        var response = await Dio().post(
          '$baseUrl/plant/isthere',
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

  List<String> generateMessage(double temp) {
    if (temp >= 18 && temp <= 25) {
      return [
        '😀', '"식물 재배에 알맞은 온도입니다."',
      ];
    } else if (temp < 18) {
      return [
        '🤧', '"온도를 올려주는 것이 좋습니다."',
      ];
    } else {
      return [
        '🥵', '"온도를 낮춰주는 것이 좋습니다."',
      ];
    }
  }

  Future<void> _fetchSensorDataAndSetImage() async {
    try {
      final sensorData = await fetchSensorData();
      int level = sensorData["level"];
      int temp = sensorData["temp"];
      int water = sensorData['water_level'];
      int disease = sensorData["disease"];
      print(sensorData);

      String temperatureStatus;
      if (temp < 18) {
        temperatureStatus = 'cold';
      } else if (temp > 25) {
        temperatureStatus = 'hot';
      } else {
        temperatureStatus = 'normal';
      }

      String waterLevel = (water == 0) ? 'normal' : 'dry';
      String diseaseStatus = (disease == 1) ? 'normal' : 'disease';

      setState(() {
        _level = level;
        // ${_level}
        _temperatureStatus =temperatureStatus;
        _waterStatus = waterLevel;
        _diseaseStatus = diseaseStatus;
        _imageUrl = 'assets/images/${_level}level/${_diseaseStatus}_${_waterStatus}_${_temperatureStatus}.png';
      });
    } catch (e) {
      print('사진 변경 중 에러 발생: $e');
    }
  }

  Widget buildSensorDataText(Map<String, dynamic> data) {
    final temp = data['temp'].toDouble();
    final tempMessages = generateMessage(temp);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              Text(
                'Level. ${data['level']}',
                style: TextStyle(
                  fontFamily: '둥근모',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.lime.shade50,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 20),
                  Text(
                    tempMessages[0],
                    style: TextStyle(fontFamily: '카페24', fontSize: 25),
                  ),
                  SizedBox(width: 20),
                  Center(
                    child: Text(
                      tempMessages[1],
                      style: TextStyle(
                        fontFamily: '카페24',
                        fontSize: 22,
                        color: Colors.red.shade500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 70),
        Container(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '"함께한지 ${data["date"]}일이 지났어요!"',
                    style: TextStyle(
                      fontFamily: '카페24',
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    thickness: 1,
                    color: Colors.green.shade800,
                  ),
                  SizedBox(height: 20),
                  FutureBuilder(
                    future: fetchSensorData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Container(
                            width: 100,
                            height: 120,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ); // 로딩중
                      } else if (snapshot.hasError) {
                        return Text('Error : ${snapshot.error}'); // 에러 처리
                      } else if (snapshot.hasData) {
                        final data = snapshot.data!;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.device_thermostat,
                                    size: 25,
                                    color: Colors.red.shade700,
                                  ),
                                  SensorDataCard(
                                      label: '온도', value: '${data['temp']}°C'),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.water_drop,
                                    size: 25,
                                    color: Colors.blueAccent.shade200,
                                  ),
                                  SensorDataCard(
                                      label: '습도',
                                      value: '${data['humidity']}%'),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.sunny,
                                    size: 25,
                                    color: Colors.amber.shade400,
                                  ),
                                  SensorDataCard(
                                      label: '조도', value: '${data['light']}lx'),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Text('No Data'); // 데이터 없음 처리
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> lightTimer(double value) async {
    try {
      final respose = await dio.get('$baseUrl/sensor/act',
          queryParameters: {'lightTimer': '$value'});
    } catch (e) {
      print('Error => $e');
    }
  }

  Future<void> lightControl(double value) async {
    try {
      final respose = await dio.get('$baseUrl/sensor/act',
          queryParameters: {'lightTimer': '$value'});
    } catch (e) {
      print('Error => $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150), // 높이
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: AppBar(
            backgroundColor: Colors.white,
            toolbarHeight: 90,
            centerTitle: true,
            //elevation: 0.0,
            actions:[
              IconButton(
                onPressed: () async {
                  final imageBytes = await fetchImage();
                  if (imageBytes != null){
                    showDialog(context: context,
                      builder: (context) => ImagePopup(imageBytes: imageBytes!),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('이미지 불러오기 실패')),
                    );
                  }
                },
                icon: Column(
                  children: [
                    Text('Live',style: TextStyle(fontFamily: '카페24',color: Colors.orangeAccent.shade700,),),
                    Icon(Icons.photo_camera, size: 40
                      ,color: Colors.orangeAccent.shade400,)
                  ],
                ),
              ),

              //💡 play 버튼
              IconButton(onPressed: () async {},
                  icon: Column(
                    children: [
                      Text('Play', style: TextStyle(fontFamily: '카페24', color: Colors.orangeAccent.shade700,),),
                      Icon(Icons.play_arrow,  size: 40
                        ,color: Colors.orangeAccent.shade400,)
                    ],
                  ))
            ],

          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      InkWell(
                        child: Container(
                          width: 250.0,
                          height: 250.0,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.lightGreen,
                              width: 2.0,
                            ),
                            image: DecorationImage(
                              image: AssetImage(_imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      FutureBuilder<Map<String, dynamic>>(
                        future: fetchSensorData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: Container(
                                width: 100,
                                height: 300,
                                child: Center(
                                    child: CircularProgressIndicator()),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error : ${snapshot.error}'),
                            );
                          } else if (snapshot.hasData) {
                            return Column(
                              children: [
                                buildSensorDataText(snapshot.data!),
                              ],
                            );
                          } else {
                            return Center(child: Text('No data'));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
              Container(
                padding: EdgeInsets.all(13.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child:
                          Text('⋄ 조명 지속시간', style: TextStyle(fontFamily:'카페24',fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            '$lightTime 시간',
                            style: TextStyle(
                              fontFamily: '카페24',
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: Slider(
                          activeColor: Colors.lightGreenAccent.shade700,
                          value: lightTime,
                          max : 10, min: 0, divisions: 10,
                          label: '${lightTime.toStringAsFixed(0)}',
                          onChanged: (value) {
                            setState(() {
                              lightTime = value;});
                            lightTimer(value);}
                      ),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '0h',
                          style: TextStyle(fontFamily: '카페24', fontSize: 16),
                        ),
                        Text(
                          '10h',
                          style: TextStyle(fontFamily: '카페24', fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(13.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('⋄ 조명 밝기', style: TextStyle(fontFamily:'카페24',fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        SizedBox(width: 20,),
                        Text('$lightPower %',style: TextStyle(fontFamily: '카페24',fontSize: 18),),
                      ],),
                    SizedBox(height: 10,),
                    Slider(
                        activeColor: Colors.lightGreenAccent.shade700,
                        value: lightPower, max : 100, min: 0, divisions: 5,
                        label: '${lightPower.toStringAsFixed(0)}',
                        onChanged: (value) {
                          setState(() {
                            lightPower = value;
                          });
                          lightControl(value);
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('0',style: TextStyle(fontFamily:'카페24',fontSize: 16),),
                        Text('100',style: TextStyle(fontFamily:'카페24',fontSize: 16),),
                      ],),
                  ],),),

              SizedBox(height: 20,),
              // 물 주기 버튼
              Container(
                padding: EdgeInsets.all(13.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child:
                      Text('⋄ 워터 펌프 on/off', style: TextStyle(fontFamily:'카페24',fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      Column(
                        children: [
                          Icon(
                          Icons.water_drop,
                          size: 40,
                          color : Colors.lightBlue.shade200
                              ),
                          SizedBox(height: 10,),
                          Text('Water Cycle')
                        ],
                      ),
                        Switch(
                          value: water_on_off,
                          onChanged: (value) {
                            setState(() {
                              water_on_off = value;
                            });
                            controlDevice('water', value);
                          },
                          activeColor: Colors.lightGreenAccent.shade700,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
