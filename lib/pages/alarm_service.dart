import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class AlarmService {
  static Future<void> initialize() async {
    // Initialize Flutter Local Notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> sendNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('alarm_sound'), // Sesuaikan suara alarm
      playSound: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Alarm Title',
      'This is the alarm notification body.',
      platformChannelSpecifics,
    );
  }

  static Future<void> setAlarm(int id, Duration duration) async {
    await AndroidAlarmManager.oneShot(
      duration,
      id,
      sendNotificationCallback,
      exact: true,
      wakeup: true,
    );
  }

  // Fungsi callback untuk Workmanager
  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      await sendNotification();
      return Future.value(true);
    });
  }

  // Callback fungsi untuk alarm
  static void sendNotificationCallback() async {
    await sendNotification();
  }
}
