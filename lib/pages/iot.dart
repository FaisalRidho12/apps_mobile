import 'package:flutter/material.dart';
import 'home.dart';
import 'profile.dart'; // Import profile.dart
import 'package:http/http.dart' as http;

class IoTContent extends StatefulWidget {
  const IoTContent({super.key});

  @override
  _IoTContentState createState() => _IoTContentState();
}

class _IoTContentState extends State<IoTContent> {
  final String _baseUrl = 'http://192.168.1.26'; // Replace with ESP8266 IP
  int _currentIndex = 1; // Index for IoT in BottomNavigationBar

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

  void _showFeedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Posisi Servo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  _moveServo(0);
                  Navigator.of(context).pop();
                },
                child: const Text('TUTUP'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _moveServo(90);
                  Navigator.of(context).pop();
                },
                child: const Text('90°'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _moveServo(180);
                  Navigator.of(context).pop();
                },
                child: const Text('BUKA'),
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
          title: const Text('Monitoring'),
          content: const Text('Monitoring information goes here.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tutup'),
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
            const SizedBox(height: 40),
            const Text(
              'Kontrol IoT',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/image-iot1.png',
              height: 200,
              fit: BoxFit.cover,
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
                    backgroundColor: Colors.white,
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
                          color: Colors.teal,
                          height: 50,
                          width: 50,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Monitoring',
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 18,
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
                    backgroundColor: Colors.white,
                    shadowColor: Colors.grey,
                  ),
                  child: SizedBox(
                    width: 120,
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons1/makan-icon.png',
                          color: Colors.teal,
                          height: 50,
                          width: 50,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Pakan',
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 18,
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
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
    );
  }
}
