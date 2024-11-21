import 'package:flutter/material.dart';

class Wifi extends StatefulWidget {
  const Wifi({super.key});

  @override
  State<Wifi> createState() => _WifiState();
}

class _WifiState extends State<Wifi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffDFF2EB),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('WiFi',style: TextStyle(fontSize: 30),),
            SizedBox(height: 30),
            Icon(
              Icons.wifi,
              size: 100,
            ),
            SizedBox(height: 30),
            ElevatedButton(child: Text('WiFi 연결'),
              onPressed: () => {},
            ),
          ],
        ),
      ),
    );
  }
}
