import 'package:cat_care/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'autenti/login.dart';
import 'autenti/splash_screen.dart';
import 'pages/home.dart';

// Plugin notifikasi global
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Inisialisasi Android Alarm Manager
  await AndroidAlarmManager.initialize();
  // Inisialisasi Workmanager
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false, // Ubah ke true untuk debugging
  );

  // Inisialisasi notifikasi
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}

// Callback untuk Workmanager
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'alarmTask') {
      // Tampilkan notifikasi ketika alarm dijalankan
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'alarm_channel_id',
        'Alarm Channel',
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
        0,
        'Scheduled Alarm',
        'Time to take action!',
        platformChannelSpecifics,
      );
      return Future.value(true);
    }
    return Future.value(false);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cat Care',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
