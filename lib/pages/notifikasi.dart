import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> schedules = [];

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('schedules');
    if (encodedData != null) {
      setState(() {
        schedules = List<Map<String, dynamic>>.from(jsonDecode(encodedData));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Notifikasi'),
        backgroundColor: Colors.brown,
      ),
      body: schedules.isEmpty
          ? const Center(
              child: Text("Belum ada jadwal yang disimpan."),
            )
          : ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(schedule['name']),
                    subtitle: Text('${schedule['date']} • ${schedule['time']}'),
                    trailing: schedule['isOn'] == true
                        ? const Icon(Icons.notifications_active, color: Colors.green)
                        : const Icon(Icons.notifications_off, color: Colors.grey),
                  ),
                );
              },
            ),
    );
  }
}
