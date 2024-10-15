import 'package:flutter/material.dart';

class IoTContent extends StatefulWidget {
  const IoTContent({super.key});

  @override
  _IoTContentState createState() => _IoTContentState();
}

class _IoTContentState extends State<IoTContent> {
  bool _isDeviceOn = false; // State for IoT device

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
          SwitchListTile(
            title: const Text('Device Status'),
            value: _isDeviceOn,
            onChanged: (bool value) {
              setState(() {
                _isDeviceOn = value; // Update IoT device state
                // Implement IoT control logic here
                print('Device turned ${_isDeviceOn ? "ON" : "OFF"}');
              });
            },
          ),
          const SizedBox(height: 20),
          // Display an image when the IoT tab is selected
          Image.asset(
            'assets/images/iot_image.png', // Add your IoT image here
            height: 200, // Adjust the height as needed
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
