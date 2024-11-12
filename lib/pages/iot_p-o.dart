import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mqtt_service.dart';

class ServoAutomaticControlPage extends StatefulWidget {
  final MqttService mqttService;

  ServoAutomaticControlPage({Key? key, required this.mqttService})
      : super(key: key);

  @override
  _ServoAutomaticControlPageState createState() =>
      _ServoAutomaticControlPageState();
}

class _ServoAutomaticControlPageState extends State<ServoAutomaticControlPage> {
  TimeOfDay? selectedTime;

  void scheduleServoOpen(TimeOfDay time) {
    final now = DateTime.now();
    final scheduledDateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);

    Duration delay = scheduledDateTime.difference(now);
    if (delay.isNegative) {
      delay +=
          const Duration(days: 1); // Set for the next day if time has passed
    }

    Future.delayed(delay, () {
      widget.mqttService.publish('catcare/servo', 'OPEN');

      Future.delayed(const Duration(seconds: 10), () {
        widget.mqttService.publish('catcare/servo', 'CLOSE');
      });
    });

    print("Servo akan terbuka otomatis pada pukul: ${time.format(context)}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pakan Otomatis',
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
        child: ElevatedButton(
          onPressed: () async {
            selectedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (selectedTime != null) {
              scheduleServoOpen(selectedTime!);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        "Jadwal Pakan Terbuka pada ${selectedTime!.format(context)}")),
              );
            }
          },
          child: const Text('Jadwal'),
        ),
      ),
    );
  }
}
