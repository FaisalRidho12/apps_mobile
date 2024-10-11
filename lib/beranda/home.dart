import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'add_schedule.dart'; // Import halaman Tambahkan Jadwal

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List untuk menyimpan jadwal yang telah ditambahkan
  List<Map<String, dynamic>> schedules = [];

  // Fetch the username from Firebase
  String get username {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Jika displayName tersedia, gunakan itu, jika tidak, fallback ke email
      print("Current User: ${user.displayName}"); // Debug log
      return user.displayName ?? user.email?.split('@')[0] ?? "User"; // Fallback ke email atau "User"
    } else {
      print("No user is currently logged in.");
      return "User"; // Nilai default
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: const AssetImage('assets/images/pp.png'), // Ganti dengan gambar profil kucing
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
              "Hi, ${username}", // Gunakan username yang didapat dari Firebase
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: const Image(
                image: AssetImage('assets/images/cat.png'), // Ganti dengan gambar kucing
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
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
                  // Navigasi ke halaman Tambahkan Jadwal dan tunggu hasilnya
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddScheduleScreen(),
                    ),
                  );

                  // Jika ada hasil yang diterima, tambahkan ke dalam daftar jadwal
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
                            // Ketika kotak jadwal ditekan, tampilkan dialog opsi
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

  // Fungsi untuk menampilkan dialog opsi (Edit dan Delete)
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
                Navigator.pop(context); // Tutup dialog

                // Arahkan ke halaman AddScheduleScreen dengan data yang ada
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddScheduleScreen(
                      initialData: schedules[index], // Kirim data yang ada
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
                Navigator.pop(context); // Tutup dialog
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
