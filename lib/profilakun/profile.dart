import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.teal, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Bagian Profile User
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/pp.png'), // Gambar profil
            ),
            const SizedBox(height: 16),
            const Text(
              'Username',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const Text(
              'username@gmail.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            // List Menu Pengaturan
            _buildMenuItem(context, Icons.settings, 'Pengaturan', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            }),
            _buildMenuItem(context, Icons.notifications, 'Notifikasi', () {
              // Aksi ketika Notifikasi ditekan
            }),
            _buildMenuItem(context, Icons.info_outline, 'Tentang Kami', () {
              // Aksi ketika Tentang Kami ditekan
            }),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Fungsi untuk membangun item menu
  Widget _buildMenuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            Icon(icon, color: Colors.teal),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, color: Colors.teal),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Colors.teal),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
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

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Akun',
          style: TextStyle(color: Colors.teal, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Bagian Profile User
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/pp.png'), // Gambar profil
            ),
            const SizedBox(height: 16),
            const Text(
              'Username',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const Text(
              'username@gmail.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            // List Menu Pengaturan Akun
            _buildAccountMenuItem(Icons.person_add, 'Tambahkan Akun', () {
              // Aksi Tambahkan Akun
            }),
            _buildAccountMenuItem(Icons.delete, 'Hapus Akun', () {
              // Aksi Hapus Akun
            }),
            _buildAccountMenuItem(Icons.edit, 'Edit Akun', () {
              // Aksi Edit Akun
            }),
            _buildAccountMenuItem(Icons.logout, 'Logout', () {
              // Aksi Logout
            }),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membangun item menu pengaturan akun
  Widget _buildAccountMenuItem(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            Icon(icon, color: Colors.teal),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, color: Colors.teal),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Colors.teal),
          ],
        ),
      ),
    );
  }
}
