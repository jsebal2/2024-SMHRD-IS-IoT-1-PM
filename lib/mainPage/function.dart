import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:async';

final dio = Dio();

late Timer _timer;


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
    final response = await dio.get('http://192.168.219.61:8000/sensor/sen',
         queryParameters: {'data' : 'good','send':'get'}
    );
    if (response.statusCode == 200) {
      // Json 데이터에서 title만 리스트로 추출
      return response.data["data"]; // JSON 데이터를 맵 형태로 반환
    }else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print("errer $e");
    throw Exception('Error : $e');
  }
}



void controlDevice(String device, bool state) async {
  try {
    Response res = await dio.get(
      'http://192.168.219.61:8000/sensor/act',
      queryParameters: {"senser": device, "state": '$state'},
    );
    print('Device $device set to ${state ? "ON" : "OFF"}');
  } catch (e) {
    print('Error controlling $device: $e');
  }
}