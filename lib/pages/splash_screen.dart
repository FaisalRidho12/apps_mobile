import 'package:flutter/material.dart';
import 'dart:async';  // For the Timer function

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF005D5D),  // Color for the background
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,  // Ubah sesuai kebutuhan
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),  // Jarak dari atas
              child: Text(
                'Selamat Datang',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,  // Posisi gambar di tengah
            child: Image.asset(
              'assets/images/logo1.png',  // Your image path
              width: 200,  // Adjust the size as needed
              height: 200,
            ),
          ),
        ],
      ),
    );
  }
}
