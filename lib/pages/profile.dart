import 'package:cat_care/autenti/login.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'home.dart'; 
import 'iot.dart';
import 'aboutus.dart';
import 'notifikasi.dart';

=======
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'iot.dart';


>>>>>>> 0a6738eaf2f941c7c0b7eed6b375675049da8c73
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
<<<<<<< HEAD
  int _currentIndex = 2; // Default index untuk Profil
=======
  int _currentIndex = 2;
>>>>>>> 0a6738eaf2f941c7c0b7eed6b375675049da8c73

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/pp.png'),
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
            _buildMenuItem(context, Icons.settings, 'Pengaturan', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            }),
            _buildMenuItem(context, Icons.notifications, 'Notifikasi', () {
<<<<<<< HEAD
              // Aksi ketika Notifikasi ditekan
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
              );
            }),
            _buildMenuItem(context, Icons.info_outline, 'Tentang Kami', () {
              // Aksi ketika Tentang Kami ditekan
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutusScreen()),
                );
=======
              
            }),
            _buildMenuItem(context, Icons.info_outline, 'Tentang Kami', () {
              
>>>>>>> 0a6738eaf2f941c7c0b7eed6b375675049da8c73
            }),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

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
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        if (index == 0) {
<<<<<<< HEAD
          // Pergi ke Home
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()), // Ambil HomeScreen dari home.dart
            (Route<dynamic> route) => false, // Hapus stack sebelumnya
          );
        } else if (index == 1) {
          // Pergi ke IoT
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const IoTContent()), // Ambil IotScreen dari home.dart
            (Route<dynamic> route) => false, // Hapus stack sebelumnya
=======
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false,
          );
        } else if (index == 1) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const IoTContent()),
            (Route<dynamic> route) => false,
>>>>>>> 0a6738eaf2f941c7c0b7eed6b375675049da8c73
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
    );
  }
}

<<<<<<< HEAD
// Halaman pengaturan (Settings)
=======
>>>>>>> 0a6738eaf2f941c7c0b7eed6b375675049da8c73
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/pp.png'),
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
            _buildAccountMenuItem(Icons.person_add, 'Tambahkan Akun', () {
              
            }),
            _buildAccountMenuItem(Icons.delete, 'Hapus Akun', () {
              _showDeleteAccountDialog(context);
            }),
            _buildAccountMenuItem(Icons.edit, 'Ganti Password', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChangePasswordWidget()),
              );
            }),
            _buildAccountMenuItem(Icons.logout, 'Logout', () {
              _showLogoutConfirmationDialog(context);
            }),
          ],
        ),
      ),
    );
  }

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
<<<<<<< HEAD
}
=======

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Penghapusan Akun'),
          content: const Text('Apakah Anda yakin ingin menghapus akun ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Iya'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteAccount(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error menghapus akun: $e')),
      );
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Iya'),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class ChangePasswordWidget extends StatefulWidget {
  const ChangePasswordWidget({super.key});

  @override
  _ChangePasswordWidgetState createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _changePassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String email = user.email!;
        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: _oldPasswordController.text,
        );

        await user.reauthenticateWithCredential(credential);

        if (_passwordController.text != _confirmPasswordController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password baru tidak sama!')),
          );
          return;
        }

        await user.updatePassword(_passwordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password berhasil diganti!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Ganti Password',
          style: TextStyle(color: Colors.teal, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password Lama',
                hintText: 'Password Lama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password Baru',
                hintText: 'Password Baru',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Ulangi Password Baru',
                hintText: 'Ulangi Password Baru',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    child: const Text('Ganti'),
                  ),
          ],
        ),
      ),
    );
  }
}
>>>>>>> 0a6738eaf2f941c7c0b7eed6b375675049da8c73
