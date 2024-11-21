import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:pm_project/Connect/Bluetooth.dart';

class Connecting extends StatefulWidget {
  const Connecting({super.key});

  @override
  State<Connecting> createState() => _ConnectingState();
}

class _ConnectingState extends State<Connecting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffDFF2EB),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('CONNECTING',style: TextStyle(fontSize: 30),),
            SizedBox(height: 30),
            Icon(
              Icons.power_settings_new,
              size: 150,
            ),
            SizedBox(height: 30),
            ElevatedButton(child: Text('화분에 연결하기'),
              onPressed: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Bluetooth())),
              },
            ),
          ],
        ),
      ),
    );
  }
}
