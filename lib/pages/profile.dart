import 'dart:io';
import 'package:cat_care/autenti/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'iot.dart';
import 'package:google_fonts/google_fonts.dart';
import 'notifikasi.dart';
import 'delete.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 2;
  User? user;
  String displayName = 'Username';
  String email = '';
  XFile? _selectedImage;
  bool _showOptions = false;
  final int _selectedIndex = 2; // Halaman awal

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser; 
    if (user != null) {
      _fetchUsername(); 
    }
    _loadImage();
  }

  Future<void> _fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        setState(() {
          displayName = userDoc['username'] ?? 'User'; // Ambil username dari Firestore
          email = user.email ?? '';
        });
      } catch (e) {
        print('Error fetching username: $e');
        setState(() {
          displayName = 'User'; // Jika terjadi error, tampilkan default username
          email = user.email ?? 'Not available';
        });
      }
    }
  }

    Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _selectedImage = pickedImage;
          _showOptions = false; // Sembunyikan opsi setelah gambar dipilih
        });
        _saveImagePath(pickedImage.path);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

    void _removeImage() {
    setState(() {
      _selectedImage = null; // Menghapus gambar dengan mengatur menjadi null
      _showOptions = false;
    });
    _clearImagePath();
  }

   // Save the image path to SharedPreferences
  Future<void> _saveImagePath(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('profile_image', imagePath);
  }

  // Load the image from SharedPreferences
  Future<void> _loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profile_image');
    if (imagePath != null) {
      setState(() {
        _selectedImage = XFile(imagePath); // Load the saved image path
      });
    }
  }

  // Clear the image path in SharedPreferences
  Future<void> _clearImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('profile_image');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(color: const Color(0xFF594545),
           fontSize: 24,
           fontWeight: FontWeight.bold,),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _showOptions = !_showOptions; // Toggle tampilan opsi saat gambar ditekan
                });
              },
              child: CircleAvatar(
                radius: 40,
                backgroundImage: _selectedImage != null
                    ? FileImage(File(_selectedImage!.path))
                    : const AssetImage('assets/images/pp.png') as ImageProvider,
              ),
            ),
            const SizedBox(height: 16),
            if (_showOptions) 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo_library),  // Ikon galeri
                    onPressed: _pickImage,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),  // Ikon tempat sampah
                    onPressed: _removeImage,
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Text(
              displayName,
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF594545)),
            ),
            Text(
              email,
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryPage()),
              );
            }),
            _buildMenuItem(context, Icons.info_outline, 'Tentang Kami', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
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
          ],
        ),
      ),
    );
  }

Widget _buildBottomNavigationBar() {
  return Container(
    margin: const EdgeInsets.all(25), // Jarak antara kotak dengan tepi layar
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
    decoration: BoxDecoration(
      color: Colors.white, // Warna latar kotak
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
      currentIndex: _currentIndex,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
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
          label: 'Account',
        ),
      ],
      backgroundColor: Colors.transparent, // Supaya transparan karena ada kotak luar
      elevation: 0, // Hilangkan bayangan default BottomNavigationBar
      selectedItemColor: const Color(0xFF594545),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: false,
    ),
  );
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


}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  User? user;
  String displayName = 'Username';
  String email = '';
  XFile? _selectedImage;
  bool _showOptions= false;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _fetchUsername();
    }
    _loadImage();
  }

  Future<void> _fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        setState(() {
          displayName = userDoc['username'] ?? 'User';
          email = user.email ?? ''; // Ambil email dari FirebaseAuth
        });
      } catch (e) {
        // print('Error fetching username: $e');
        setState(() {
          displayName = 'User'; // Jika terjadi error, tampilkan default username
          email = user.email ?? 'Not available'; // Jika email tidak ditemukan
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _selectedImage = pickedImage;
          _showOptions = false; // Sembunyikan opsi setelah gambar dipilih
        });
        _saveImagePath(pickedImage.path);
      }
    } catch (e) {
      // print('Error picking image: $e');
    }
  }

    void _removeImage() {
    setState(() {
      _selectedImage = null; // Menghapus gambar dengan mengatur menjadi null
      _showOptions = false;
    });
    _clearImagePath();
  }

    Future<void> _saveImagePath(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('profile_image', imagePath);
  }

  // Load the image from SharedPreferences
  Future<void> _loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profile_image');
    if (imagePath != null) {
      setState(() {
        _selectedImage = XFile(imagePath); // Load the saved image path
      });
    }
  }

  // Clear the image path in SharedPreferences
  Future<void> _clearImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('profile_image');
  }

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
          style: GoogleFonts.poppins(color: const Color(0xFF594545),
          fontSize: 24,
          fontWeight: FontWeight.bold,),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
           GestureDetector(
              onTap: () {
                setState(() {
                  _showOptions = !_showOptions; // Toggle tampilan opsi saat gambar ditekan
                });
              },
              child: CircleAvatar(
                radius: 40,
                backgroundImage: _selectedImage != null
                    ? FileImage(File(_selectedImage!.path))
                    : const AssetImage('assets/images/pp.png') as ImageProvider,
              ),
            ),
            const SizedBox(height: 16),
            if (_showOptions) 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo_library),  // Ikon galeri
                    onPressed: _pickImage,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),  // Ikon tempat sampah
                    onPressed: _removeImage,
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Text(
              displayName,
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF594545)),
            ),
            Text(
              email,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            _buildAccountMenuItem(Icons.delete, 'Hapus Akun', () {
              // _showDeleteAccountDialog(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeleteAccountConfirmationPage(),
                ),
              );
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
              onPressed: () async {
                // Melakukan logout dengan Firebase
                await FirebaseAuth.instance.signOut();

                // Menghapus status login dari SharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);  // Set status login menjadi false

                // Arahkan pengguna ke halaman login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
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
          style: GoogleFonts.poppins(color: const Color(0xFF594545),
          fontSize: 24,
          fontWeight: FontWeight.bold,),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF594545),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Ganti',
                          style: GoogleFonts.poppins(color: Colors.white),
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