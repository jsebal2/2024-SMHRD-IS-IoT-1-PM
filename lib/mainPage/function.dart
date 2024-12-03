import 'dart:typed_data' as typed_data;

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dio = Dio();

late Timer _timer;

final FlutterSecureStorage secureStorage = FlutterSecureStorage();
bool light_on_off = true;
bool wind_on_off = true;
bool water_on_off = true;
bool isLoading = true;
bool hasPlantData = false;

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

Future<typed_data.Uint8List?> fetchImage() async {
  try {
    final response = await dio.get(
      'http://192.168.219.61:8000/pic/pull', options: Options(responseType: ResponseType.bytes));

    if (response.statusCode == 200) {
      return typed_data.Uint8List.fromList(response.data);
    } else {
      print('실패 ${response.statusCode}');
    }
  } catch (e) {
    print('에러!!!!!!!!! $e');
  } return null;
}

class ImagePopup extends StatelessWidget {
  final typed_data.TypedData imageBytes;

  ImagePopup({required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 300,
        height: 300,
        child: Column(
          children: [
            Expanded(child: Image.memory(
                imageBytes as typed_data.Uint8List),),
            ElevatedButton(onPressed: () {Navigator.of(context).pop();},
                child: Text("close"))
          ],
        ),
      ),
    );
  }
}

