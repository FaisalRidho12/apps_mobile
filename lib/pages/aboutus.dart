import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AboutUsScreen(),
    );
  }
}

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Tambahkan navigasi kembali jika diperlukan
          },
        ),
        title: const Text("Tentang Kami"),
        centerTitle: true,
        backgroundColor: Colors.white, // Tetap putih
      ),
      body: Container(
        color: const Color(0xFFFFEDDB), // Warna coklat muda
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              color: const Color(0xFFFFEDDB), // Warna coklat muda
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/paw.png', height: 40), // Gambar tapak
                      const SizedBox(width: 16),
                      Image.asset('assets/paw.png', height: 40),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Hello, Cat Care apps is about how to do u care about ur cat. There is fitures u can use likes notifications u set, for remember u about ur cat wich is eat, medicine, bath, etc. Also u can set or control ur cat places to eat like set the time.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white, // Tetap putih
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(16.0),
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  children: [
                    CatCard(
                      name: "EL RIDHO",
                      imagePath: "assets/cat1.png",
                      asal: "Jakarta",
                      jurusan: "Teknik Komputer",
                      prodi: "S1 Teknik Komputer",
                      role: "Ketua Tim",
                    ),
                    CatCard(
                      name: "EL DIKA",
                      imagePath: "assets/cat2.png",
                      asal: "Bandung",
                      jurusan: "Teknik Komputer",
                      prodi: "S1 Teknik Informatika",
                      role: "Anggota Tim",
                    ),
                    CatCard(
                      name: "EL FULAY",
                      imagePath: "assets/cat3.png",
                      asal: "Surabaya",
                      jurusan: "Teknik Komputer",
                      prodi: "S1 Sistem Informasi",
                      role: "Anggota Tim",
                    ),
                    CatCard(
                      name: "EL AMIR",
                      imagePath: "assets/cat4.png",
                      asal: "Yogyakarta",
                      jurusan: "Teknik Komputer",
                      prodi: "S1 Teknologi Informasi",
                      role: "Anggota Tim",
                    ),
                    CatCard(
                      name: "EL FYAN",
                      imagePath: "assets/cat5.png",
                      asal: "Medan",
                      jurusan: "Teknik Komputer",
                      prodi: "S1 Rekayasa Perangkat Lunak",
                      role: "Anggota Tim",
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              color: const Color(0xFFFFEDDB), // Warna coklat muda
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/paw.png', height: 40),
                  const SizedBox(width: 16),
                  Image.asset('assets/paw.png', height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CatCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final String asal;
  final String jurusan;
  final String prodi;
  final String role;

  const CatCard({
    Key? key,
    required this.name,
    required this.imagePath,
    required this.asal,
    required this.jurusan,
    required this.prodi,
    required this.role,
  }) : super(key: key);

  void _showDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Asal: $asal"),
              Text("Jurusan: $jurusan"),
              Text("Prodi: $prodi"),
              Text("Sebagai: $role"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetails(context),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 80), // Gambar kucing
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
