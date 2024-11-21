import 'package:flutter/material.dart';
import 'package:pm_project/Connect/Bluetooth.dart';
import 'package:pm_project/Connect/WiFi.dart';
class Bluetooth extends StatefulWidget {
  const Bluetooth({super.key});

  @override
  State<Bluetooth> createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffDFF2EB),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('BLUETOOTH',style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 30),
            Icon(
              Icons.bluetooth,
              size: 100,
            ),
            SizedBox(height: 30),
            ElevatedButton(child: Text('내 기기 찾기'),
              onPressed: () => {
                Navigator.pop(context,
                    MaterialPageRoute(builder: (context) => const Bluetooth())),
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(child: Text('WIFI 연결하기'),
              onPressed: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Wifi())),
              },
            ),
          ],
        ),
      ),
    );
  }
}
