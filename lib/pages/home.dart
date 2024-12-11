import 'dart:async';
// import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Import untuk notifications
import 'package:audioplayers/audioplayers.dart'; // Import untuk alarm sound
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'add_schedule.dart'; // Import halaman Tambahkan Jadwal
import 'package:image_picker/image_picker.dart';
import 'iot.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> schedules = [];
  List<String> imagePaths = [];
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AudioPlayer audioPlayer = AudioPlayer();
  bool isAlarmPlaying = false; 
  String username = 'User';
  bool _showDeleteButton = false;
  int _selectedImageIndex = -1; 
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // _initializeNotifications();
    _startAutoSlide(); // Memulai animasi otomatis 
    // _loadSchedules();
    _loadSchedulesFromFirebase();
    _checkSchedules();
    _fetchUsername();
    _pageController = PageController(initialPage: 0);
    _loadImages();
    Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
    _scheduleBackgroundAlarms();
  }

  @override
  void dispose() {
    _timer?.cancel(); // timer dibatalkan 
    audioPlayer.dispose();
    _pageController.dispose();
    super.dispose();
  }

   Future<void> _fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        username = userDoc['username'] ?? 'User';
      });
    }
  }

    Widget _buildAnimatedIcon(int index, String assetPath) {
  bool isSelected = _selectedIndex == index;

  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
    decoration: BoxDecoration(
      color: isSelected ? Colors.white : Colors.transparent, // Lingkaran putih
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
    padding: EdgeInsets.all(isSelected ? 12 : 0), // Padding bertambah saat dipilih
    child: ImageIcon(
      AssetImage(assetPath),
      size: isSelected ? 36 : 28, // Ikon lebih besar saat dipilih
      color: isSelected ? const Color(0xFF594545) : Colors.grey,
    ),
  );
}
  
  // Fungsi untuk memilih gambar dari galeri
  Future<void> _loadImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedPaths = prefs.getStringList('images') ?? [];

    setState(() {
      imagePaths = savedPaths;

      // Tambahkan gambar default jika belum ada gambar
      if (imagePaths.isEmpty) {
        imagePaths.addAll([
          'assets/images/cat1.png',
          'assets/images/cat2.png',
          'assets/images/cat3.png',
          'assets/images/cat4.png',
        ]);
      }
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagePaths.add(pickedFile.path); // Tambahkan path baru
      });

      // Simpan gambar baru ke SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList('images', imagePaths);

      // Pindah ke gambar terakhir dengan animasi
      Future.delayed(Duration.zero, () {
        _pageController.animateToPage(
          imagePaths.length - 1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  // Fungsi untuk menghapus gambar
  void _deleteImage(int index) async {
    setState(() {
      imagePaths.removeAt(index); // Hapus gambar dari list
    });

    // Simpan perubahan ke SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('images', imagePaths);
  }

  // void _initializeNotifications() {
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('@mipmap/ic_launcher');
  //   const InitializationSettings initializationSettings =
  //       InitializationSettings(android: initializationSettingsAndroid);    
  //   flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_pageController.hasClients) {
        setState(() {
          _currentPage = (_currentPage + 1) % imagePaths.length;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
        _startAutoSlide(); // Panggil kembali untuk loop animasi
      }
    });
  }


  // Future<void> _saveSchedules() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String encodedData = jsonEncode(schedules);
  //   await prefs.setString('schedules', encodedData);
  // }

  // Future<void> _loadSchedules() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? encodedData = prefs.getString('schedules');
  //   if (encodedData != null) {
  //     setState(() {
  //       schedules = List<Map<String, dynamic>>.from(jsonDecode(encodedData));
  //     });
  //   }
  // }

Future<void> _loadSchedulesFromFirebase() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final schedulesSnapshot = await FirebaseFirestore.instance
        .collection('schedules')
        .where('userId', isEqualTo: user.uid)
        .get();
    
    setState(() {
      schedules = schedulesSnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id; // Menyertakan ID dokumen
        return data;
      }).toList();
    });
  }
}


Future<void> _saveSchedules() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    for (var schedule in schedules) {
      try {
        if (schedule['id'] != null) { 
          // Jika jadwal sudah ada (dengan ID), lakukan update
          await FirebaseFirestore.instance.collection('schedules').doc(schedule['id']).update({
            'name': schedule['name'],
            'date': schedule['date'],
            'time': schedule['time'],
            'isOn': schedule['isOn'],
            'userId': user.uid, // Ensure userId is updated as well
          });
        } else {
          // Jika jadwal baru, tambahkan ke Firestore
          var docRef = await FirebaseFirestore.instance.collection('schedules').add({
            'name': schedule['name'],
            'date': schedule['date'],
            'time': schedule['time'],
            'isOn': schedule['isOn'],
            'userId': user.uid,
          });
          // Simpan ID dokumen baru
          schedule['id'] = docRef.id;
        }
      } catch (e) {
        // print('Failed to save schedule: $e');
      }
    }
    // Sinkronkan ulang data setelah menyimpan
    await _loadSchedulesFromFirebase();
  }
}


  void _scheduleBackgroundAlarms() {
    for (var schedule in schedules) {
      if (schedule['isOn'] == true) {
        DateTime scheduleDateTime = DateTime.parse("${schedule['date']} ${schedule['time']}");
        Duration timeDifference = scheduleDateTime.difference(DateTime.now());
        if (timeDifference.isNegative) continue;

        Workmanager().registerOneOffTask(
          "alarm_${schedule['name']}_${scheduleDateTime.millisecondsSinceEpoch}",
          "alarmTask",
          inputData: {
            "name": schedule['name'],
            "date": schedule['date'],
            "time": schedule['time'],
          },
          initialDelay: timeDifference,
          constraints: Constraints(
            networkType: NetworkType.not_required,
            requiresBatteryNotLow: true,
          ),
        );
      }
    }
  }

  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);

      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'Notification Channel ID',
        'Schedule Reminder',
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
        0,
        'Scheduled Reminder',
        'It\'s time for ${inputData?['name']}!',
        platformChannelSpecifics,
      );

      return Future.value(true);
    });
  }


  void _showNotification(String scheduleName) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'Notfikasi jadwal',
      'Pengingat jadwal',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('sound'),
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

  void _playAlarm() async {
    if (!isAlarmPlaying) {
      isAlarmPlaying = true;
      await audioPlayer.setSource(AssetSource('alarm_sound.mp3'));
      audioPlayer.setReleaseMode(ReleaseMode.loop);
      await audioPlayer.resume();
    }
  }

  void _stopAlarm() async {
    if (isAlarmPlaying) {
      isAlarmPlaying = false;
      await audioPlayer.stop();
    }
  }

  void _checkSchedules() {
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      final now = DateTime.now();
      for (var schedule in schedules) {
        if (schedule['isOn'] == true) {
          DateTime scheduleDateTime = DateTime.parse("${schedule['date']} ${schedule['time']}");
          if (now.year == scheduleDateTime.year &&
              now.month == scheduleDateTime.month &&
              now.day == scheduleDateTime.day &&
              now.hour == scheduleDateTime.hour &&
              now.minute == scheduleDateTime.minute) {
            _showNotification(schedule['name']);
          }
        }
      }
    });
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70), // Tambahkan ruang di atas
              Container(
                width: double.infinity,
                height: 70,
                // padding: const EdgeInsets.only(left: 16.0, top: 30.0),
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8EA),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
              ),
              child: Text(
                "Hi, $username",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF594545),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                setState(() {
                  // _showAddButton = !_showAddButton;
                  _showDeleteButton = !_showDeleteButton;
                });
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: SizedBox(
                  height: 240,
                  width: double.infinity,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index; // Update halaman saat berubah
                      });
                    },
                    itemCount: imagePaths.length,
                    itemBuilder: (context, index) {
                      final imagePath = imagePaths[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImageIndex = index; // Update index gambar yang dipilih
                            _showDeleteButton = true; // Tampilkan tombol hapus saat gambar diklik
                          });
                        },
                        child: imagePath.startsWith('assets/')
                            ? Image.asset(imagePath, fit: BoxFit.cover)
                            : Image.file(File(imagePath), fit: BoxFit.cover),
                      );
                    },
                  ),
                ),
              ),
            ),
            if (_showDeleteButton && _selectedImageIndex != -1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo_library),
                    onPressed: _pickImage, // Menambah gambar
                    tooltip: 'Tambah Gambar',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Tampilkan dialog konfirmasi hapus gambar
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Hapus Gambar'),
                          content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                imagePaths[_selectedImageIndex].startsWith('assets/')
                                ? Image.asset(
                                    imagePaths[_selectedImageIndex], height: 100)
                                : Image.file(
                                    File(imagePaths[_selectedImageIndex]),
                                    height: 100),
                                const Text('Apakah Anda yakin ingin menghapus gambar ini?'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Tutup dialog
                                },
                                child: const Text('Batal'),
                              ),
                            TextButton(
                              onPressed: () {
                                _deleteImage(_selectedImageIndex); // Hapus gambar
                                Navigator.pop(context); // Tutup dialog
                              },
                              child: const Text('Hapus'),
                            ),
                          ],
                        ),
                      );
                    },
                    tooltip: 'Hapus Gambar',
                  ),
                ],
              ),
            const SizedBox(height: 6),
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
                trailing: const Icon(Icons.add, color: Color(0xFF594545)),
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
            Text(
              "Jadwal Terbaru",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF594545),
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
                                      // _checkSchedules();
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
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(25), // Jarak antara kotak dengan tepi layar
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
        decoration: BoxDecoration(
          color: Colors.white,// Warna latar kotak
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
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
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
              label: 'Profile',
            ),
          ],
          backgroundColor: Colors.transparent, // Supaya transparan karena ada kotak luar
          elevation: 0, // Hilangkan bayangan default BottomNavigationBar
          selectedItemColor: const Color(0xFF594545),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
        ),
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
          // Tombol Edit
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              // Mengarahkan ke halaman edit jadwal
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddScheduleScreen(
                    initialData: schedules[index],
                    // initialData: schedules[index], // Mengirim data jadwal ke halaman Edit
                  ),
                ),
              );

              // Jika ada perubahan data dari halaman edit, update ke Firebase
              if (result != null && result is Map<String, dynamic>) {
                setState(() {
                  // Update data lokal
                  schedules[index] = {
                    // 'id': schedules[index]['id'],
                    ...schedules[index],
                    'name': result['name'],
                    'date': result['date'],
                    'time': result['time'],
                    'isOn': result['isOn'],
                  };
                });

                // Perbarui data di Firebase
                await _updateScheduleInFirebase(schedules[index], result['id']);
              }
            },
            child: const Text('Edit'),
          ),
          // Tombol Delete
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              // Hapus data lokal
              final scheduleToDelete = schedules[index];
              setState(() {
                schedules.removeAt(index);
              });

              // Hapus data dari Firebase
              await _deleteScheduleFromFirebase(scheduleToDelete['id']);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}

// Fungsi untuk memperbarui jadwal di Firebase
Future<void> _updateScheduleInFirebase(Map<String, dynamic> updatedSchedule, String scheduleId) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await FirebaseFirestore.instance
        .collection('schedules')
        .doc(scheduleId) // Gunakan ID jadwal untuk mengidentifikasi dokumen
        .update({
          'name': updatedSchedule['name'],
          'date': updatedSchedule['date'],
          'time': updatedSchedule['time'],
          'isOn': updatedSchedule['isOn'],
        });
    await _loadSchedulesFromFirebase();
  }
}


  Future<void> _deleteScheduleFromFirebase(String scheduleId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('schedules')
          .doc(scheduleId) // Menghapus berdasarkan ID dokumen
          .delete();
      await _loadSchedulesFromFirebase();
    }
  }
}