import 'package:cat_care/firebase_options.dart';  // untuk konek ke firebase
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'autenti/login.dart';  // ngambil atau import login
import 'autenti/splash_screen.dart';  // untuk splash screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  // supaya bisa konek ke firebase
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),  // saat di play akan ke splas screen dulu
        '/login': (context) => const LoginScreen(),  // lanjut ke menu login
      },
    );
  }
}
