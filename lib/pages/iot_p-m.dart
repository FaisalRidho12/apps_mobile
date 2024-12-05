import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mqtt_service.dart';

class ServoManualControlPage extends StatefulWidget {
  final MqttService mqttService;

  ServoManualControlPage({Key? key, required this.mqttService})
      : super(key: key);

  @override
  _ServoManualControlPageState createState() => _ServoManualControlPageState();
}

class _ServoManualControlPageState extends State<ServoManualControlPage> {
  String _servoStatus = 'Tertutup'; // Status awal adalah tertutup
  Color _statusColor = Colors.red; // Warna awal (merah untuk tertutup)

  // Fungsi untuk memperbarui status servo
  void _updateServoStatus(String status) {
    setState(() {
      if (status == 'Terbuka') {
        _servoStatus = status;
        _statusColor = Colors.green; // Hijau untuk terbuka
      } else {
        _servoStatus = status;
        _statusColor = Colors.red; // Merah untuk tertutup
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pakan Manual',
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20, // Lebar indikator
                    height: 20, // Tinggi indikator
                    decoration: BoxDecoration(
                      color: _statusColor, // Warna indikator sesuai status
                      shape: BoxShape.circle, // Bentuk lingkaran
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$_servoStatus',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _statusColor, // Warna teks mengikuti status
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  widget.mqttService.publish('catcare/servo', 'OPEN');
                  _updateServoStatus('Terbuka'); // Perbarui status ke terbuka
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF594545), // Warna tombol
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'BUKA',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  widget.mqttService.publish('catcare/servo', 'CLOSE');
                  _updateServoStatus('Tertutup'); // Perbarui status ke tertutup
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color(0xFF594545), // Warna tombol untuk konsistensi
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'TUTUP',
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
