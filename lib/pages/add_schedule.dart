import 'package:flutter/material.dart';

class AddScheduleScreen extends StatefulWidget {
  // Parameter tambahan untuk menerima data yang ada
  final Map<String, dynamic>? initialData;

  const AddScheduleScreen({super.key, this.initialData});

  @override
  _AddScheduleScreenState createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Jika ada initialData, isi controller dengan data tersebut
    if (widget.initialData != null) {
      _nameController.text = widget.initialData!['name'] ?? '';
      _dateController.text = widget.initialData!['date'] ?? '';
      _timeController.text = widget.initialData!['time'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () {
            _onBackPressed();
          },
        ),
        title: const Text(
          'Tambahkan Jadwal',
          style: TextStyle(
            color: Colors.teal,
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
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                _onSavePressed();
              },
              child: const Text(
                'Simpan',
                style: TextStyle(
                  color: Colors.white,
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
      // Menampilkan dialog konfirmasi
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text('Anda yakin untuk kembali?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                },
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                  Navigator.pop(context); // Kembali ke halaman sebelumnya
                },
                child: const Text('Ya'),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.pop(context); // Kembali jika semua kolom terisi
    }
  }

  void _onSavePressed() {
    // Cek jika semua kolom terisi
    if (_nameController.text.isNotEmpty && _dateController.text.isNotEmpty && _timeController.text.isNotEmpty) {
      // Buat map jadwal yang baru
      final scheduleData = {
        'name': _nameController.text,
        'date': _dateController.text,
        'time': _timeController.text,
      };

      Navigator.pop(context, scheduleData); // Kembali dengan mengirimkan data
    } else {
      // Menampilkan notifikasi jika ada kolom yang belum terisi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan isi semua kolom sebelum menyimpan.')),
      );
    }
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
            _dateController.text = "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
          });
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: _dateController,
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
