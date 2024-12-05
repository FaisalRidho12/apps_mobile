import 'package:flutter/material.dart';
import 'home.dart';
import 'profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mqtt_service.dart'; // Import mqtt_service.dart
import 'iot_p-m.dart';
import 'iot_p-o.dart';
import 'iot_m-s.dart';
import 'iot_m-k.dart';

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
  final int _selectedIndex = 1; // Halaman awal

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
                    // Loading state, show loading GIF
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: Image.asset(
                              'assets/images/loading-cat.gif'), // Custom loading GIF
                        ),
                        SizedBox(height: 0),
                        Text(
                          'Loading data...',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF594545),
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    double stockLevel = double.tryParse(snapshot.data!) ??
                        0; // Convert stock level to double
                    stockLevel = stockLevel.clamp(
                        0, 100); // Clamp percentage between 0 and 100

                    return Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'Stok Pakan',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF594545),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Stack(
                            children: [
                              // Battery outline
                              Container(
                                width: 200,
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFF594545),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              // Battery fill based on stock level
                              Container(
                                width: (200 *
                                    stockLevel /
                                    100), // Dynamic width based on stock level
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF594545), // Fill color
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                ),
                              ),
                              // Battery percentage text
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                    '${stockLevel.toStringAsFixed(1)}%', // Stock percentage
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
                  height: 10), // Space between the stock level and buttons
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
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15), // Rounded corners for the dialog
          ),
          title: Text(
            'Monitoring',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF594545), // Title color
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 5), // Space between content and buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TemperaturePage(
                        dhtStream:
                            mqttService.dhtStream, // Send temperature stream
                      ),
                    ),
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
                      Icons.thermostat, // Icon for temperature
                      color: const Color(0xFF594545),
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Suhu',
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
                  Navigator.pop(context); // Close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HumidityPage(
                        dhtStream:
                            mqttService.dhtStream, // Send humidity stream
                      ),
                    ),
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
                      Icons.water_drop, // Icon for humidity
                      color: const Color(0xFF594545),
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Kelembapan',
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
                    color: const Color(0xFF594545),
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
                            color: const Color(0xFF594545),
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
                            color: const Color(0xFF594545),
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
    return Container(
      margin: const EdgeInsets.all(25), // Jarak antara kotak dengan tepi layar
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white, // Warna latar kotak
        borderRadius: BorderRadius.circular(30), // Membuat sudut membulat
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow lembut
            blurRadius: 12,
            spreadRadius: 3,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const IoTScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(0, 'assets/icons1/home.png'),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(1, 'assets/icons1/iot.png'),
            label: 'IoT',
          ),
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(2, 'assets/icons1/profil.png'),
            label: 'Account',
          ),
        ],
        backgroundColor:
            Colors.transparent, // Supaya transparan karena ada kotak luar
        elevation: 0, // Hilangkan bayangan default BottomNavigationBar
        selectedItemColor: const Color(0xFF594545),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
      ),
    );
  }

  Widget _buildAnimatedIcon(int index, String assetPath) {
    bool isSelected = _selectedIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color:
            isSelected ? Colors.white : Colors.transparent, // Lingkaran putih
        shape: BoxShape.circle,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ]
            : [],
      ),
      padding:
          EdgeInsets.all(isSelected ? 12 : 0), // Padding bertambah saat dipilih
      child: ImageIcon(
        AssetImage(assetPath),
        size: isSelected ? 36 : 28, // Ikon lebih besar saat dipilih
        color: isSelected ? const Color(0xFF594545) : Colors.grey,
      ),
    );
  }

  @override
  void dispose() {
    mqttService.disconnect(); // Disconnect MQTT when screen is disposed
    super.dispose();
  }
}
