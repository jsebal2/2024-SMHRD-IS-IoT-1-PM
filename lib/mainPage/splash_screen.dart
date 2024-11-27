import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'MainPage.dart';
import 'Login.dart';

class SplasgScreen extends StatefulWidget {
  const SplasgScreen({super.key});

  @override
  State<SplasgScreen> createState() => _SplasgScreenState();
}

class _SplasgScreenState extends State<SplasgScreen> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String? token;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    String? retrievedtoken = await secureStorage.read(key: 'authToken');
    setState(() {
      token = retrievedtoken;
    });

    Future.delayed(Duration(seconds: 2), () {
      if (retrievedtoken != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Mainpage()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: token == null
            ? CircularProgressIndicator()
            : Text('Token: $token', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
