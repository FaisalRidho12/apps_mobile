import 'package:cat_care/firebase_options.dart';  // Only needed if firebase_options.dart exists
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/login.dart';  // Ensure login.dart exists in the 'pages' folder
import 'pages/splash_screen.dart';  // Importing the splash screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensure widget binding is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  // Initialize Firebase
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        '/': (context) => SplashScreen(),  // Set SplashScreen as the initial route
        '/login': (context) => LoginScreen(),  // Ensure login.dart is correctly set up
      },
    );
  }
}
