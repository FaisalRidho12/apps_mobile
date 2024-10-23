import 'dart:async';
<<<<<<< HEAD
<<<<<<< HEAD
import 'dart:convert';
=======
import 'profile.dart';
import 'iot.dart'; // Import halaman IoT
>>>>>>> f18df35e014028300de072e2557027b1e90e1327
=======
import 'profile.dart';
import 'iot.dart'; // Import halaman IoT
>>>>>>> f18df35e014028300de072e2557027b1e90e1327
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Import untuk notifikasi
import 'package:audioplayers/audioplayers.dart'; // Import for alarm sound
import 'package:shared_preferences/shared_preferences.dart';
import 'add_schedule.dart'; // Import halaman Tambahkan Jadwal
import 'iot.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> schedules = [];
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AudioPlayer audioPlayer = AudioPlayer();
  bool isAlarmPlaying = false; // Menambahkan status alarm
  String _username = "User";

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _startAutoSlide(); // Memulai animasi otomatis 
    _loadSchedules();
    _checkSchedules();
    _loadUsername();
  }

  @override
  void dispose() {
    _timer?.cancel(); // timer dibatalkan 
    audioPlayer.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // Inisialisasi notifikasi
  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
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

// Fungsi untuk menyimpan data jadwal ke SharedPreferences
  Future<void> _saveSchedules() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = jsonEncode(schedules); // Encode data ke format JSON
    await prefs.setString('schedules', encodedData); // Simpan data
  }

  // Fungsi untuk memuat data jadwal dari SharedPreferences
  Future<void> _loadSchedules() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('schedules');
    if (encodedData != null) {
      setState(() {
        schedules = List<Map<String, dynamic>>.from(jsonDecode(encodedData)); // Decode data dari JSON
      });
    }
  }

  // Fungsi untuk mengecek apakah jadwal sudah mencapai waktunya
  void _checkSchedules() {
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      final now = TimeOfDay.now();
      for (var schedule in schedules) {
        if (schedule['isOn'] == true) {
          TimeOfDay scheduleTime = _parseTime(schedule['time']);
          if (now.hour == scheduleTime.hour && now.minute == scheduleTime.minute) {
            _showNotification(schedule['name']);
            _playAlarm(); // Memanggil fungsi untuk memutar alarm
          }
        }
      }
    });
  }

  // Parse waktu dari string ke TimeOfDay
  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  // Tampilkan notifikasi
  void _showNotification(String scheduleName) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'Notfikasi jadwal',
      'Pengingat jadwal',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Jadwal Tiba',
      'Waktunya untuk $scheduleName',
      platformChannelSpecifics,
    );
  }

  // Mainkan suara alarm
  void _playAlarm() async {
    if (!isAlarmPlaying) { // Memastikan alarm hanya diputar sekali
      isAlarmPlaying = true; // Mengubah status alarm
      print("Memulai alarm...");
      await audioPlayer.setSource(AssetSource('alarm_sound.mp3'));
      print("Sumber audio diatur...");
      audioPlayer.setReleaseMode(ReleaseMode.loop); // Mengulangi suara alarm
      await audioPlayer.resume();
      print("Alarm diputar...");
    }
  }

  // Matikan suara alarm
  void _stopAlarm() async {
    if (isAlarmPlaying) {
      isAlarmPlaying = false; // Mengubah status alarm
      await audioPlayer.stop(); // Hentikan suara alarm
      print("Alarm dihentikan.");
    }
  }

  // Fungsi untuk memuat username dari SharedPreferences
  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? "User"; // Muat username atau default ke "User"
    });
  }

  // Fungsi untuk menyimpan username ke SharedPreferences
  Future<void> _saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username); // Simpan username
  }

  // Ambil username dari pengguna yang login
  void _getAndSaveUsername() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _username = user.displayName ?? user.email?.split('@')[0] ?? "User";
      _saveUsername(_username); // Simpan username
    }
  }

  // String get username {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     print("Current User: ${user.displayName}");
  //     return user.displayName ?? user.email?.split('@')[0] ?? "User";
  //   } else {
  //     print("No user is currently logged in.");
  //     return "User";
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // Panggil untuk menyimpan username jika ada pengguna yang login
    _getAndSaveUsername();

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
              "Hi, $_username",
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
                      _saveSchedules();
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
                                    _saveSchedules();
                                    if (value){
                                      _checkSchedules();
                                    } else {
                                      _stopAlarm();
                                    }
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
<<<<<<< HEAD
<<<<<<< HEAD
        currentIndex: 0, // Menetapkan Home sebagai halaman awal
        onTap: (int index) {
          if (index == 0) {
            Navigator.pushReplacement(
=======
=======
>>>>>>> f18df35e014028300de072e2557027b1e90e1327
        currentIndex: _currentPage, // Track the current index
        onTap: (int index) {
          setState(() { 
            _currentPage = index; // Update current page index
          });

          // Handle navigation based on the index
          if (index == 0) { // Home page
            Navigator.push(
<<<<<<< HEAD
>>>>>>> f18df35e014028300de072e2557027b1e90e1327
=======
>>>>>>> f18df35e014028300de072e2557027b1e90e1327
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
<<<<<<< HEAD
<<<<<<< HEAD
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const IoTScreen(), // Mengarahkan ke halaman IoT
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(), // Mengarahkan ke halaman Profile
=======
=======
>>>>>>> f18df35e014028300de072e2557027b1e90e1327
          } else if (index == 1) { // IoT page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const IoTContent(), // Arahkan ke halaman IoT
              ),
            );
          } else if (index == 2) { // Profile page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
<<<<<<< HEAD
>>>>>>> f18df35e014028300de072e2557027b1e90e1327
=======
>>>>>>> f18df35e014028300de072e2557027b1e90e1327
              ),
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
                    _saveSchedules();
                  });
                }
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  schedules.removeAt(index);
                  _saveSchedules();
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
