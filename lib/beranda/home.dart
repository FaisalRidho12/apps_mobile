import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'add_schedule.dart'; // Import halaman Tambahkan Jadwal

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> schedules = [];
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide(); // Memulai animasi otomatis saat inisialisasi
  }

  @override
  void dispose() {
    _timer?.cancel(); // Pastikan timer dibatalkan saat screen dihancurkan
    _pageController.dispose();
    super.dispose();
  }

  // Fungsi untuk memulai animasi slide otomatis
  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      // Memindahkan halaman menggunakan PageController
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  String get username {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("Current User: ${user.displayName}");
      return user.displayName ?? user.email?.split('@')[0] ?? "User";
    } else {
      print("No user is currently logged in.");
      return "User";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/pp.png'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi, $username",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                setState(() {
                  // Manual slide ketika gambar ditekan
                  _currentPage = (_currentPage + 1) % 3;
                  _pageController.animateToPage(
                    _currentPage,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                });
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index; // Update halaman saat berubah manual
                      });
                    },
                    children: const [
                      Image(
                        image: AssetImage('assets/images/cat1.png'),
                        fit: BoxFit.cover,
                      ),
                      Image(
                        image: AssetImage('assets/images/cat2.png'),
                        fit: BoxFit.cover,
                      ),
                      Image(
                        image: AssetImage('assets/images/cat3.png'),
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                title: const Text('Tambahkan Jadwal'),
                trailing: const Icon(Icons.add, color: Colors.teal),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddScheduleScreen(),
                    ),
                  );

                  if (result != null && result is Map<String, dynamic>) {
                    setState(() {
                      schedules.insert(0, {
                        'name': result['name'],
                        'date': result['date'],
                        'time': result['time'],
                        'isOn': true,
                      });
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Jadwal Terbaru",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: schedules.isEmpty
                  ? const Center(child: Text("Belum ada jadwal yang ditambahkan."))
                  : ListView.builder(
                      itemCount: schedules.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _showOptionDialog(context, index);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(schedules[index]['name']),
                              subtitle: Text('${schedules[index]['date']} • ${schedules[index]['time']}'),
                              trailing: Switch(
                                value: schedules[index]['isOn'] ?? true,
                                onChanged: (value) {
                                  setState(() {
                                    schedules[index]['isOn'] = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }

  void _showOptionDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih opsi di bawah ini'),
          content: const Text('Pilih untuk mengedit atau menghapus jadwal.'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddScheduleScreen(
                      initialData: schedules[index],
                    ),
                  ),
                );

                if (result != null && result is Map<String, dynamic>) {
                  setState(() {
                    schedules[index] = {
                      'name': result['name'],
                      'date': result['date'],
                      'time': result['time'],
                      'isOn': schedules[index]['isOn'],
                    };
                  });
                }
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  schedules.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
