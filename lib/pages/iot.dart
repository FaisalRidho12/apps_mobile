import 'package:flutter/material.dart';
import 'home.dart';
import 'profile.dart'; // Import file profile.dart
import 'package:http/http.dart' as http;

class IoTContent extends StatefulWidget {
  const IoTContent({super.key});

  @override
  _IoTContentState createState() => _IoTContentState();
}

class _IoTContentState extends State<IoTContent> {
  final String _baseUrl =
      'http://192.168.251.103'; // Ganti dengan alamat IP ESP8266 Anda
  int _currentIndex = 1; // Indeks untuk IoT di BottomNavigationBar

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'IoT Control',
          style: TextStyle(color: Colors.teal, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Center(
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
            Image.asset(
              'assets/images/image-iot1.png', // Tambahkan gambar IoT Anda di sini
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
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
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Fungsi untuk Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        if (index == 0) {
          // Pergi ke Home
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false, // Hapus stack sebelumnya
          );
        } else if (index == 2) {
          // Pergi ke Profil
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
            (Route<dynamic> route) => false, // Hapus stack sebelumnya
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
