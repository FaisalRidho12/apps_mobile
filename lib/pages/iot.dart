import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IoTContent extends StatefulWidget {
  const IoTContent({super.key});

  @override
  _IoTContentState createState() => _IoTContentState();
}

class _IoTContentState extends State<IoTContent> {
  final String _baseUrl =
      'http://192.168.251.103'; // Replace with your ESP8266 IP address

  Future<void> _moveServo(int position) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/servo/$position'));
      if (response.statusCode == 200) {
        print('Servo moved to $position degrees!');
      } else {
        print('Failed to move servo. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Kontrol IoT',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 20),
          // Display an image when the IoT tab is selected
          Image.asset(
            'assets/images/image-iot1.png', // Add your IoT image here
            height: 200, // Adjust the height as needed
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          // Buttons to control the servo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _moveServo(0),
                child: const Text('0°'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => _moveServo(90),
                child: const Text('90°'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => _moveServo(180),
                child: const Text('180°'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
