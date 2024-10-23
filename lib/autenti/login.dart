import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';  // Import SharedPreferences
import 'signup.dart';
import 'package:cat_care/pages/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? errorMessage;
  bool _isLoading = false;
  bool _obscuretext = true;

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        errorMessage = "Silahkan masukkan email dan password.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      errorMessage = null; // Reset error message
    });

    try {
      // Sign in user
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      
      // Simpan status login ke SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);  // Menyimpan status login

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()), // Ganti dengan HomeScreen Anda
      );
    } on FirebaseAuthException catch (e) {
      print('Error code: ${e.code}'); // Log kode error untuk debugging
      setState(() {
        switch (e.code) {
          case 'wrong-password':
            errorMessage = 'Email atau password salah.'; // Pesan untuk email/password salah
            break;
          case 'invalid-email':
            errorMessage = 'Alamat email tidak valid.';
            break;
          case 'user-disabled':
            errorMessage = 'Akun ini telah dinonaktifkan.';
            break;
          case 'user-not-found':
            errorMessage = 'Akun tidak ditemukan.';
            break;
          default:
            errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan yang tidak terduga. Silakan coba lagi.';
      });
    } finally {
      setState(() {
        _isLoading = false; // Menghilangkan indikator loading
      });
    }
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      setState(() {
        errorMessage = "Silahkan masukkan email untuk reset password.";
      });
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      setState(() {
        errorMessage = "Email reset password terkirim!";
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message; // Tampilkan pesan error dari Firebase
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan yang tidak terduga. Silakan coba lagi.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/logo2.png', // Path ikon hewan
                  height: 150,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'E-mail',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.teal[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Password',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.teal[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscuretext ? Icons.visibility_off : Icons.visibility,
                                color: Colors.teal,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscuretext = !_obscuretext;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscuretext,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: _resetPassword,
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupScreen()),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
