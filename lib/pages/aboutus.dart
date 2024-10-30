import 'package:flutter/material.dart';

class AboutusScreen extends StatelessWidget {
  const AboutusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Tentang Kami',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Bagian atas dengan ikon tapak kucing dan deskripsi
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.teal,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(Icons.pets, size: 50, color: Colors.white),
                    Icon(Icons.pets, size: 50, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "Hello, Cat Care apps is about how to do u care about ur cat. There is fitures u can use likes notifications u set, for remember u about ur cat wich is eat, medicine, bath, etc. Also u can set or control ur cat places to eat like set the time.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Bagian grid dengan gambar dan nama tim
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              padding: const EdgeInsets.all(16),
              children: const [
                TeamMember(name: 'EL RIDHO', imagePath: 'assets/images/cat1.png'),
                TeamMember(name: 'EL DIKA', imagePath: 'assets/images/cat2.png'),
                TeamMember(name: 'EL FULAY', imagePath: 'assets/images/cat3.png'),
                TeamMember(name: 'EL AMIR', imagePath: 'assets/images/cat4.png'),
                TeamMember(name: 'EL FYAN', imagePath: 'assets/images/cat5.png'),
              ],
            ),
          ),
          // Bagian bawah dengan ikon tapak kucing
          Container(
            color: Colors.teal,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.pets, size: 50, color: Colors.white),
                Icon(Icons.pets, size: 50, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TeamMember extends StatelessWidget {
  final String name;
  final String imagePath;

  const TeamMember({required this.name, required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Image.asset(
                imagePath,
                height: 80,
                width: 80,
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
