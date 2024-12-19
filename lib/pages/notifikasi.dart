import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> schedules = []; // Menyimpan daftar jadwal
  List<Map<String, dynamic>> filteredSchedules = []; // Menyimpan daftar jadwal setelah filter
  DateTime? selectedDate; // Tanggal yang dipilih untuk filter

  @override
  void initState() {
    super.initState();
    _loadSchedulesFromFirebase();
  }

  Future<void> _loadSchedulesFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final schedulesSnapshot = await FirebaseFirestore.instance
          .collection('schedules')
          .where('userEmail', isEqualTo: user.email)
          .get();

      setState(() {
        schedules = schedulesSnapshot.docs.map((doc) {
          var data = doc.data();
          data['id'] = doc.id; // Menyertakan ID dokumen
          return data;
        }).toList();
        filteredSchedules = schedules; // Awalnya semua data ditampilkan
      });
    }
  }

  void _filterSchedulesByDate(DateTime date) {
    setState(() {
      selectedDate = date;
      filteredSchedules = schedules.where((schedule) {
        if (schedule['date'] == null) return false;
        return schedule['date'] == DateFormat('yyyy-MM-dd').format(date);
      }).toList();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      _filterSchedulesByDate(pickedDate);
    }
  }

  Future<void> _deleteSchedule(String id) async {
    await FirebaseFirestore.instance.collection('schedules').doc(id).delete();
    setState(() {
      schedules.removeWhere((schedule) => schedule['id'] == id);
      filteredSchedules.removeWhere((schedule) => schedule['id'] == id);
    });
  }

  Future<void> _deleteAllSchedules() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final batch = FirebaseFirestore.instance.batch();
      for (var schedule in schedules) {
        final docRef = FirebaseFirestore.instance.collection('schedules').doc(schedule['id']);
        batch.delete(docRef);
      }
      await batch.commit();
      setState(() {
        schedules.clear();
        filteredSchedules.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () => _selectDate(context),
          ),
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Hapus Semua History'),
                  content: Text('Apakah Anda yakin ingin menghapus semua history?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Hapus'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await _deleteAllSchedules();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (selectedDate != null)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Tanggal: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: filteredSchedules.isEmpty
                ? Center(
                    child: Text('Tidak ada data untuk tanggal ini.'),
                  )
                : ListView.builder(
                    itemCount: filteredSchedules.length,
                    itemBuilder: (context, index) {
                      final schedule = filteredSchedules[index];
                      return Dismissible(
                        key: Key(schedule['id']), // Kunci unik untuk item
                        direction: DismissDirection.endToStart, // Geser ke kiri untuk menghapus
                        background: Container(
                          color: const Color.fromARGB(255, 255, 17, 0).withOpacity(0.5),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) async {
                          await _deleteSchedule(schedule['id']);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('History "${schedule['name']}" dihapus')),
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text(schedule['name'] ?? 'No Title'),
                            subtitle: Text(schedule['time'] ?? 'No Description'),
                            trailing: Text(schedule['date'] ?? 'No Date'),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}