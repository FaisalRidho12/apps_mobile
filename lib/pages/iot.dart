import 'package:flutter/material.dart';
import 'home.dart';
import 'profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mqtt_service.dart'; // Import mqtt_service.dart
import 'iot_p-m.dart';
import 'iot_p-o.dart';

class IoTScreen extends StatefulWidget {
  const IoTScreen({super.key});

  @override
  _IoTScreenState createState() => _IoTScreenState();
}

class _IoTScreenState extends State<IoTScreen> {
  int _currentIndex = 1; // Index for IoT in BottomNavigationBar
  late MqttService mqttService;
  String temperature = ""; // Variable to hold temperature
  String humidity = ""; // Variable to hold humidity

  @override
  void initState() {
    super.initState();
    mqttService = MqttService();

    // Set callback for connection status changes
    mqttService.onConnectionChanged = (isConnected) {
      setState(() {
        // Update UI or perform actions based on connection status
      });
    };

    // Set callback for receiving DHT data
    mqttService.onDhtDataReceived = (temp, hum) {
      setState(() {
        temperature = temp; // Update temperature
        humidity = hum; // Update humidity
      });
    };

    // Connect to MQTT broker
    mqttService.connect();
  }

  void _showFeedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15), // Rounded corners for the dialog
          ),
          title: Text(
            'Pakan',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF594545), // Title color
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Display current food stock level from HC-SR04 sensor
              StreamBuilder<String>(
                stream: mqttService
                    .foodStockStream, // Assuming you have a stream for the stock level
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Show loading while waiting for data
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return Text(
                      'Stok Pakan: ${snapshot.data}%', // Display stock level in percentage
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF594545),
                      ),
                    );
                  } else {
                    return Text(
                      'Tidak ada data stok.',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF594545),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(
                  height: 20), // Space between the stock level and buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ServoManualControlPage(mqttService: mqttService),
                    ), // Open manual control page
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: const Color(0xFFFFF8EA), // Background color
                  foregroundColor: const Color(0xFF594545), // Text color
                  elevation: 5,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app, // Icon for manual control
                      color: const Color(0xFF594545),
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Manual',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF594545),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), // Space between buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ServoAutomaticControlPage(mqttService: mqttService),
                    ), // Open automatic control page
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: const Color(0xFFFFF8EA), // Background color
                  foregroundColor: const Color(0xFF594545), // Text color
                  elevation: 5,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer, // Icon for automatic control
                      color: const Color(0xFF594545),
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Otomatis',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF594545),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMonitoringDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Monitoring',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF594545),
            ),
          ),
          content: StreamBuilder(
            stream: mqttService.dhtStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data as Map<String, String>;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8EA), // Background color
                            borderRadius:
                                BorderRadius.circular(12), // Rounded corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.3), // Shadow color
                                spreadRadius: 2, // Shadow spread
                                blurRadius: 5, // Shadow blur effect
                                offset: const Offset(0, 3), // Shadow position
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.thermostat, color: Color(0xFF594545)),
                              const SizedBox(width: 8),
                              Text(
                                'Suhu: ${data['temperature']} °C',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF594545),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8EA), // Background color
                            borderRadius:
                                BorderRadius.circular(12), // Rounded corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.3), // Shadow color
                                spreadRadius: 2, // Shadow spread
                                blurRadius: 5, // Shadow blur effect
                                offset: const Offset(0, 3), // Shadow position
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.water_drop, color: Color(0xFF594545)),
                              const SizedBox(width: 8),
                              Text(
                                'Kelembapan: ${data['humidity']} %',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF594545),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Image.asset(
                        'assets/images/loading-cat.gif', // Path to your GIF
                        fit: BoxFit.cover, // Ensures the GIF scales properly
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Loading data...',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF594545),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Tutup',
                style: GoogleFonts.poppins(
                  color: Color(0xFF594545),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8EA),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: const Offset(0, 3), // Offset for the shadow
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(
                  8.0, 30.0, 8.0, 8.0), // Increased top padding
              child: Center(
                child: Text(
                  'Kontrol IoT',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF594545),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8EA),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/image-iot1.png',
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _showMonitoringDialog,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: const Color(0xFFFFF8EA),
                    shadowColor: Colors.grey,
                  ),
                  child: SizedBox(
                    width: 120,
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons1/monitoring-icon.png',
                          color: const Color(0xFF594545),
                          height: 50,
                          width: 50,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Monitoring',
                          style: GoogleFonts.poppins(
                            color: Color(0xFF594545),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _showFeedDialog,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: const Color(0xFFFFF8EA),
                    shadowColor: Colors.grey,
                  ),
                  child: SizedBox(
                    width: 120,
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons1/pakan-icon.png',
                          color: const Color(0xFF594545),
                          height: 50,
                          width: 50,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Pakan',
                          style: GoogleFonts.poppins(
                            color: Color(0xFF594545),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        if (index == 0) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false,
          );
        } else if (index == 2) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
            (Route<dynamic> route) => false,
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/icons1/home.png'), size: 24),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/icons1/iot.png'), size: 24),
          label: 'IoT',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/icons1/profil.png'), size: 24),
          label: 'Profile',
        ),
      ],
      selectedItemColor: const Color(0xFF594545),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
    );
  }

  @override
  void dispose() {
    mqttService.disconnect(); // Disconnect MQTT when screen is disposed
    super.dispose();
  }
}
