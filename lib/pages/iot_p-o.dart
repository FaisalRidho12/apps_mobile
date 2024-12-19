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
  List<Map<String, dynamic>> schedules = [];

  void scheduleServoOpen(TimeOfDay time, int scheduleIndex) {
    final now = DateTime.now();
    final scheduledDateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);

    Duration delay = scheduledDateTime.difference(now);
    if (delay.isNegative) {
      delay += const Duration(days: 1);
    }

    // Menambahkan hitungan mundur
    setState(() {
      schedules[scheduleIndex]['countdown'] = delay.inSeconds;
    });

    // Update hitungan mundur setiap detik
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        if (schedules[scheduleIndex]['countdown'] > 0) {
          schedules[scheduleIndex]['countdown']--;
        }
      });
      return schedules[scheduleIndex]['countdown'] > 0;
    });

    Future.delayed(delay, () {
      widget.mqttService.publish('catcare/servo', 'OPEN');
      setState(() {
        schedules[scheduleIndex]['status'] = 'OPEN';
      });
      print("Servo will open automatically at: ${time.format(context)}");

      // Tutup servo secara otomatis setelah 5 detik (contoh durasi)
      Future.delayed(const Duration(seconds: 5), () {
        widget.mqttService.closeServo();
        setState(() {
          schedules[scheduleIndex]['status'] = 'CLOSED';
        });
      });
    });
  }

  Future<void> _showCustomTimePicker(BuildContext context,
      {int? scheduleIndex}) async {
    TimeOfDay initialTime = scheduleIndex != null
        ? schedules[scheduleIndex]['time']
        : TimeOfDay.now();
    DateTime tempPickedTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      initialTime.hour,
      initialTime.minute,
    );

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext builder) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFFFFF8EA),
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
          height: 300,
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
                      if (scheduleIndex != null) {
                        // Edit existing schedule
                        schedules[scheduleIndex]['time'] = pickedTime;
                      } else {
                        // Add new schedule
                        schedules.add({
                          'time': pickedTime,
                          'status': 'CLOSED', // Default status is CLOSED
                        });
                      }
                    });
                    // ignore: unnecessary_null_comparison
                    if (pickedTime != null) {
                      scheduleServoOpen(
                          pickedTime, scheduleIndex ?? schedules.length - 1);
                      ScaffoldMessenger.of(context)
                          .hideCurrentSnackBar(); // Hapus SnackBar sebelumnya jika ada
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 8.0),
                          child: Text(
                            scheduleIndex != null
                                ? "Jadwal diperbarui menjadi ${pickedTime.format(context)}"
                                : "Jadwal baru ditambahkan pada ${pickedTime.format(context)}",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1, // Make text a single line
                            overflow: TextOverflow
                                .ellipsis, // Ensure long text doesn't overflow
                          ),
                        ),
                        backgroundColor:
                            const Color(0xFF594545).withOpacity(0.5),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.only(
                          bottom: 90,
                          left: 20,
                          right: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                      ));
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
                    'Simpan Jadwal',
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
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF594545), // Warna teks khusus
          ),
        ),
        backgroundColor: const Color(0xFFFFF8EA), // Warna beige terang
        elevation: 4, // Memberikan efek bayangan standar
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8EA), // Pastikan warna tetap sama
            boxShadow: [
              BoxShadow(
                color:
                    Colors.grey.withOpacity(0.3), // Bayangan yang lebih halus
                spreadRadius: 2, // Menentukan area sebar bayangan
                blurRadius: 5, // Mengatur kelembutan bayangan
                offset: const Offset(0, 3), // Posisi bayangan
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                return Card(
                    margin: EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal:
                            20.0), // Menambahkan margin agar lebih terpisah
                    elevation: 5, // Menambahkan bayangan
                    shadowColor: Colors.black
                        .withOpacity(0.1), // Menambahkan warna bayangan
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // Membuat sudut yang lebih bulat
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal:
                              12.0), // Mengurangi padding agar lebih rapat
                      tileColor: Color(0xFFFFF8EA).withOpacity(0.5),
                      leading: Container(
                        width: 14, // Menyesuaikan ukuran ikon
                        height: 14, // Menyesuaikan ukuran ikon
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: schedules[index]['status'] == 'OPEN'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      title: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "${schedules[index]['time'].format(context)}",
                              style: GoogleFonts.poppins(
                                fontSize:
                                    18, // Menyesuaikan ukuran teks agar tidak terlalu besar
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF4A4A4A),
                              ),
                            ),
                            TextSpan(
                              text:
                                  "  ${schedules[index]['countdown'] != null ? '${(schedules[index]['countdown'] / 60).floor()}m ${schedules[index]['countdown'] % 60}s' : ''}",
                              style: GoogleFonts.poppins(
                                fontSize:
                                    14, // Menyesuaikan ukuran teks agar tidak terlalu besar
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF4A4A4A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize
                            .min, // Agar elemen di Row tidak memakan ruang lebih
                        children: [
                          // Edit button
                          AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            child: IconButton(
                              icon: Icon(Icons.edit,
                                  color: Colors.blue,
                                  size: 20), // Menyesuaikan ukuran ikon
                              onPressed: () {
                                _showCustomTimePicker(context,
                                    scheduleIndex: index);
                              },
                            ),
                          ),
                          // Delete button
                          AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            child: IconButton(
                              icon: Icon(Icons.delete,
                                  color: Colors.red,
                                  size: 20), // Menyesuaikan ukuran ikon
                              onPressed: () {
                                setState(() {
                                  schedules.removeAt(index);
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6.0, horizontal: 6.0),
                                    child: Text(
                                      "Jadwal ${index + 1} dihapus",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  backgroundColor:
                                      const Color(0xFF594545).withOpacity(0.5),
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.only(
                                      bottom: 90, left: 20, right: 20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  elevation: 4,
                                ));
                              },
                            ),
                          ),
                        ],
                      ),
                    ));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                _showCustomTimePicker(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF594545),
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
