import 'package:cat_care/autenti/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';
import 'iot.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 2;
  User? user;
  String displayName = 'Username';
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser; 
    if (user != null) {
      _fetchUsername(); 
    }
  }
  Future<void> _fetchUsername() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (snapshot.exists) {
        setState(() {
          displayName = snapshot.get('displayName') ?? 'Username';
        });
      } else {
        print('Dokumen tidak ditemukan');
      }
    } catch (e) {
      print('Error fetching username: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(color: const Color(0xFF594545), fontSize: 24),
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
            Text(
              displayName,
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF594545)),
            ),
            Text(
              user?.email ?? 'username@gmail.com',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            _buildMenuItem(context, Icons.settings, 'Pengaturan', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            }),
            _buildMenuItem(context, Icons.notifications, 'Notifikasi', () {
              
            }),
            _buildMenuItem(context, Icons.info_outline, 'Tentang Kami', () {
              
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
            Icon(icon, color: const Color(0xFF594545)),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.poppins(fontSize: 18, color: const Color(0xFF594545)),
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
      selectedItemColor: const Color(0xFF594545),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
    );
  }
}
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
          icon: const Icon(Icons.arrow_back, color: Color(0xFF594545)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Akun',
          style: GoogleFonts.poppins(color: const Color(0xFF594545), fontSize: 24),
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
            Text(
              'Username',
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF594545)),
            ),
            Text(
              'username@gmail.com',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            _buildAccountMenuItem(Icons.person_add, 'Tambahkan Akun', () {}),
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
            Icon(icon, color: const Color(0xFF594545)),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.poppins(fontSize: 18, color: const Color(0xFF594545)),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Color(0xFF594545)),
          ],
        ),
      ),
    );
  }
  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Hapus Akun',
            style: GoogleFonts.poppins(),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus akun ini?',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .delete();
                    await user.delete();
                    await FirebaseAuth.instance.signOut();
                  } catch (e) {
                    print("Error menghapus akun: $e");
                  }
                }
              },
              child: Text(
                'Hapus',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        );
      },
    );
  }
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: GoogleFonts.poppins(),
          ),
          content: Text(
            'Apakah Anda yakin ingin logout?',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(),
              ),
            ),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                });
              },
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(),
              ),
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
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  Future<void> _changePassword() async {
    setState(() {
      _isLoading = true;
    });
    try {
      User? user = _auth.currentUser;
      String email = user?.email ?? '';

      // Re-authenticate user
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: _oldPasswordController.text,
      );

      await user?.reauthenticateWithCredential(credential);

      if (_newPasswordController.text == _confirmPasswordController.text) {
        await user?.updatePassword(_newPasswordController.text);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Sukses',
              style: GoogleFonts.poppins(),
            ),
            content: Text(
              'Password telah diubah.',
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(),
                ),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Error',
              style: GoogleFonts.poppins(),
            ),
            content: Text(
              'Password baru dan konfirmasi password tidak cocok.',
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Error',
            style: GoogleFonts.poppins(),
          ),
          content: Text(
            'Password lama salah atau terjadi kesalahan: $e',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        ),
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
        title: Text(
          'Ganti Password',
          style: GoogleFonts.poppins(color: const Color(0xFF594545), fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF594545)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        toolbarHeight: 70, // Mengurangi tinggi toolbar untuk mendekatkan judul ke konten
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16), // Menambah jarak untuk menyesuaikan posisi
              Text(
                'Password',
                style: GoogleFonts.poppins(fontSize: 18, color: const Color(0xFF594545)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _oldPasswordController,
                obscureText: !_oldPasswordVisible,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFD3D3D3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Password lama',
                  hintStyle: GoogleFonts.poppins(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _oldPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFF594545),
                    ),
                    onPressed: () {
                      setState(() {
                        _oldPasswordVisible = !_oldPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _newPasswordController,
                obscureText: !_newPasswordVisible,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFD3D3D3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Password baru',
                  hintStyle: GoogleFonts.poppins(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _newPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFF594545),
                    ),
                    onPressed: () {
                      setState(() {
                        _newPasswordVisible = !_newPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: !_confirmPasswordVisible,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFD3D3D3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Ulangi password baru',
                  hintStyle: GoogleFonts.poppins(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _confirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFF594545),
                    ),
                    onPressed: () {
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _changePassword,
                        child: Text(
                          'Ganti',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF594545),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
