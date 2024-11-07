import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mqtt_service.dart';

class ServoManualControlPage extends StatelessWidget {
  final MqttService mqttService;

  ServoManualControlPage({Key? key, required this.mqttService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pakan Manual',
          style: GoogleFonts.poppins(
            fontSize: 24, // You can adjust the font size as needed
            fontWeight: FontWeight.bold,
            color: Color(0xFF594545), // Customize the text color if needed
          ),
        ),
        backgroundColor: const Color(0xFFFFF8EA), // Updated background color
        elevation: 5, // Add shadow to AppBar
        shadowColor: Colors.grey.withOpacity(0.5), // Shadow color with opacity
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                mqttService.publish('catcare/servo', 'OPEN');
              },
              child: const Text('BUKA'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                mqttService.publish('catcare/servo', 'CLOSE');
              },
              child: const Text('TUTUP'),
            ),
          ],
        ),
      ),
    );
  }
}
