import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
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
  String _servoStatus = 'Tertutup'; // Initial status is closed
  Color _statusColor = Colors.red; // Initial color (red for closed)
  IconData _statusIcon = Icons.lock; // Initial icon (lock for closed)

  void scheduleServoOpen(TimeOfDay time) {
    final now = DateTime.now();
    final scheduledDateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);

    Duration delay = scheduledDateTime.difference(now);
    if (delay.isNegative) {
      delay += const Duration(
          days: 1); // Schedule for the next day if time has passed
    }

    Future.delayed(delay, () {
      widget.mqttService.publish('catcare/servo', 'OPEN');
      setState(() {
        _servoStatus = 'Terbuka';
        _statusColor = Colors.green;
        _statusIcon = Icons.lock_open; // Open lock icon
      });

      Future.delayed(const Duration(seconds: 10), () {
        widget.mqttService.publish('catcare/servo', 'CLOSE');
        setState(() {
          _servoStatus = 'Tertutup';
          _statusColor = Colors.red;
          _statusIcon = Icons.lock; // Closed lock icon
        });
      });
    });

    print("Servo will open automatically at: ${time.format(context)}");
  }

  Future<void> _showCustomTimePicker(BuildContext context) async {
    TimeOfDay initialTime = TimeOfDay.now();
    DateTime tempPickedTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      initialTime.hour,
      initialTime.minute,
    );

    await showModalBottomSheet(
      context: context,
      backgroundColor:
          Colors.transparent, // Transparent background for custom container
      builder: (BuildContext builder) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFFFFF8EA), // Light background color
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5,
                offset: Offset(0, -3),
              ),
            ],
          ),
          height: 300, // Adjust height for better UI
          child: Column(
            children: [
              const SizedBox(height: 15),
              Text(
                "Pilih Jam Pakan",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF594545),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm,
                  initialTimerDuration: Duration(
                      hours: initialTime.hour, minutes: initialTime.minute),
                  onTimerDurationChanged: (Duration changedtimer) {
                    setState(() {
                      tempPickedTime = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        changedtimer.inHours,
                        changedtimer.inMinutes % 60,
                      );
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    final pickedTime = TimeOfDay.fromDateTime(tempPickedTime);
                    setState(() {
                      selectedTime = pickedTime;
                    });
                    if (selectedTime != null) {
                      scheduleServoOpen(selectedTime!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Jadwal Pakan Terbuka pada ${selectedTime!.format(context)}",
                            style: GoogleFonts.poppins(),
                          ),
                          backgroundColor: const Color(0xFF594545),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF594545),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Setel Jadwal',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pakan Otomatis',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF594545),
          ),
        ),
        backgroundColor: const Color(0xFFFFF8EA),
        elevation: 15,
        shadowColor: Colors.grey.withOpacity(0.5),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Status Indicator
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
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  _showCustomTimePicker(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF594545),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Jadwal',
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
