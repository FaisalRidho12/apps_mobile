import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

class AddScheduleScreen extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const AddScheduleScreen({super.key, this.initialData});

  @override
  _AddScheduleScreenState createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  bool _isOn = true; //status alarm aktif/tidak

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _nameController.text = widget.initialData!['name'] ?? '';
      _dateController.text = widget.initialData!['date'] ?? '';
      _timeController.text = widget.initialData!['time'] ?? '';
      _isOn = widget.initialData!['isOn'] ?? true; // Mengisi status alarm
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF5E3C3C)),
          onPressed: () {
            _onBackPressed();
          },
        ),
        title: Text(
          'Tambahkan Jadwal',
          style: GoogleFonts.poppins(
            color: const Color(0xFF5E3C3C),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildTextField('Nama jadwal', controller: _nameController),
            const SizedBox(height: 16),
            _buildDateField('Atur tanggal'),
            const SizedBox(height: 16),
            _buildTimeField('Atur jam'),
            const SizedBox(height: 16),
            _buildTextField('Tambahkan detail'),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E3C3C),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                _onSavePressed();
              },
              child: Text(
                'Simpan',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onBackPressed() {
    if (_nameController.text.isEmpty || _dateController.text.isEmpty || _timeController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text('Anda yakin untuk kembali?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
                child: const Text('Ya'),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _onSavePressed() async {
    if (_nameController.text.isEmpty) {
      _showErrorMessage('Nama jadwal belum diisi.');
    } else if (_dateController.text.isEmpty) {
      _showErrorMessage('Tanggal belum diatur.');
    } else if (_timeController.text.isEmpty) {
      _showErrorMessage('Jam belum diatur.');
    } else {
      final scheduleData = {
        'name': _nameController.text,
        'date': _dateController.text,
        'time': _timeController.text,
        'isOn': _isOn,
      };

      if (widget.initialData != null && widget.initialData!['id'] != null) {
        scheduleData['id'] = widget.initialData!['id'];
      }

      // Mengonversi tanggal dan waktu menjadi DateTime
      String dateTimeString = '${_dateController.text} ${_timeController.text}';
      DateTime dateTime = DateFormat('yyyy-MM-dd HH:mm').parse(dateTimeString); // Pastikan formatnya sesuai

      // Cek jika tanggal/waktu tidak di masa lalu
      if (dateTime.isBefore(DateTime.now())) {
        _showErrorMessage('Tanggal dan waktu harus di masa depan.');
        return;
      }

      // Menjadwalkan alarm
      await AndroidAlarmManager.oneShotAt(
        dateTime, // Waktu alarm
        dateTime.millisecondsSinceEpoch, // Gunakan waktu sebagai ID // ID alarm
        callbackDispatcher, // Fungsi callback
        exact: true, // Jadwalkan dengan tepat
        wakeup: true, // Bangunkan perangkat
      );

      Navigator.pop(context, scheduleData);
    }
  }

void _showErrorMessage(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: GoogleFonts.poppins(color: Colors.white), // Warna teks putih
      ),
      backgroundColor: const Color(0xFF594545), // Warna latar belakang coklat
    ),
  );
}


  Widget _buildTextField(String hint, {TextEditingController? controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDateField(String hint) {
    return GestureDetector(
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );

        if (selectedDate != null) {
          setState(() {
            _dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
          });
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: _dateController,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: Icon(Icons.calendar_today, color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeField(String hint) {
    return GestureDetector(
      onTap: () async {
        TimeOfDay? selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (selectedTime != null) {
          setState(() {
            _timeController.text = "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";
          });
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: _timeController,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: Icon(Icons.access_time, color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}

// Fungsi callback yang akan dipanggil saat alarm berbunyi
void callbackDispatcher() {
  // Logika untuk menangani alarm
  print("Alarm Triggered!");
}
