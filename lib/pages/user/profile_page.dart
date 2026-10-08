import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final int userId;
  final String nama;
  final String email;

  const ProfilePage({
    super.key,
    required this.userId,
    required this.nama,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.person,
                size: 55,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              nama,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              email,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            Card(
              child: ListTile(
                leading: const Icon(Icons.badge),
                title: const Text('ID Pengguna'),
                subtitle: Text(userId.toString()),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email'),
                subtitle: Text(email),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Nama'),
                subtitle: Text(nama),
              ),
            ),
          ],
        ),
      ),
    );
  }
}