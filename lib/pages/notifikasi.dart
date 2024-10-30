import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildNotificationItem(
            icon: Icons.notifications,
            text: 'Kucing anda waktunya ngobat',
          ),
          _buildNotificationItem(
            icon: Icons.notifications,
            text: 'Kucing anda waktunya makan',
          ),
          _buildNotificationItem(
            icon: Icons.notifications,
            text: 'Kucing anda waktunya mandi',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({required IconData icon, required String text}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.shade100, // Sesuai dengan latar belakang pada gambar
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: NotificationScreen(),
  ));
}
