import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mqtt_service.dart';

class ServoManualControlPage extends StatefulWidget {
  final MqttService mqttService;

  ServoManualControlPage({Key? key, required this.mqttService})
      : super(key: key);

  @override
  _ServoManualControlPageState createState() => _ServoManualControlPageState();
}

class _ServoManualControlPageState extends State<ServoManualControlPage> {
  String _servoStatus = 'Tertutup'; // Initial status is closed
  Color _statusColor = Colors.red; // Initial color (red for closed)
  IconData _statusIcon = Icons.lock; // Initial icon (lock for closed)

  // Function to update the servo status
  void _updateServoStatus(String status) {
    setState(() {
      if (status == 'Terbuka') {
        _servoStatus = status;
        _statusColor = Colors.green; // Green for open
        _statusIcon = Icons.lock_open; // Lock open icon
      } else {
        _servoStatus = status;
        _statusColor = Colors.red; // Red for closed
        _statusIcon = Icons.lock; // Lock closed icon
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pakan Manual',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF594545), // Custom text color
          ),
        ),
        backgroundColor: const Color(0xFFFFF8EA), // Light beige color
        elevation: 15,
        shadowColor: Colors.grey.withOpacity(0.5), // Shadow with opacity
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _statusIcon,
                    color: _statusColor,
                    size: 40, // Icon size
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$_servoStatus',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _statusColor, // Text color changes with status
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  widget.mqttService.publish('catcare/servo', 'OPEN');
                  _updateServoStatus('Terbuka'); // Update status to open
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF594545), // Button color
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'BUKA',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  widget.mqttService.publish('catcare/servo', 'CLOSE');
                  _updateServoStatus('Tertutup'); // Update status to closed
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color(0xFF594545), // Same color for consistency
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'TUTUP',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
