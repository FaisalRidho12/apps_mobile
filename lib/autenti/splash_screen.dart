import 'package:flutter/material.dart';
import 'dart:async'; // For the Timer function
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Menggunakan Timer untuk memberikan delay pada splash screen
    Timer(const Duration(seconds: 2), () {
      if (isLoggedIn) {
        Navigator.of(context)
            .pushReplacementNamed('/home'); // Jika sudah login, ke halaman home
      } else {
        Navigator.of(context).pushReplacementNamed(
            '/login'); // Jika belum login, ke halaman login
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAB886D), // Color for the background
      body: Stack(
        children: [
          // const Align(
          //   alignment: Alignment.topCenter,  // Ubah sesuai kebutuhan
          //   child: Padding(
          //     padding: EdgeInsets.only(top: 150.0),  // Jarak dari atas
          //     child: Text(
          //       'Selamat Datang',
          //       style: TextStyle(
          //         fontSize: 35,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // ),
          Align(
            alignment: Alignment.center, // Posisi gambar di tengah
            child: Image.asset(
              'assets/images/logoo.png', // Your image path
              width: 200, // Adjust the size as needed
              height: 200,
            ),
          ),
        ],
      ),
    );
  }
}
