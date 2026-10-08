import 'package:flutter/material.dart';

import '../auth/login_page.dart';
import 'kuesioner_page.dart';
import 'hasil_page.dart';
import 'profile_page.dart';
import 'tentang_page.dart';
import 'ekstrakurikuler_page.dart';

class DashboardPage extends StatelessWidget {
  final int userId;
  final String nama;
  final String email;

  const DashboardPage({
    super.key,
    required this.userId,
    required this.nama,
    required this.email,
  });

  // =====================================
  // LOGOUT
  // =====================================

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Keluar'),
          content: const Text(
            'Apakah kamu yakin ingin keluar dari akun?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                  (route) => false,
                );
              },
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }

  // =====================================
  // BUILD
  // =====================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyEkskul'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Keluar',
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),

      // =====================================
      // BODY
      // =====================================

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // =====================================
            // SAPAAN
            // =====================================

            Text(
              'Halo, $nama! 👋',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Temukan ekstrakurikuler yang sesuai dengan minat kamu.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 30),

            // =====================================
            // CARD UTAMA
            // =====================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                    size: 40,
                  ),

                  SizedBox(height: 15),

                  Text(
                    'Cari Ekskul yang Cocok',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    'Isi kuesioner untuk mengetahui rekomendasi ekstrakurikuler berdasarkan minat kamu.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // =====================================
            // JUDUL MENU
            // =====================================

            const Text(
              'Menu',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // =====================================
            // BARIS MENU 1
            // =====================================

            Row(
              children: [
                Expanded(
                  child: _MenuCard(
                    icon: Icons.quiz_outlined,
                    title: 'Kuesioner',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => KuesionerPage(
                            userId: userId,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: _MenuCard(
                    icon: Icons.recommend_outlined,
                    title: 'Hasil',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HasilPage(
                            userId: userId,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // =====================================
            // BARIS MENU 2
            // =====================================

            Row(
              children: [
                Expanded(
                  child: _MenuCard(
                    icon: Icons.groups_outlined,
                    title: 'Ekstrakurikuler',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const EkstrakurikulerPage(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: _MenuCard(
                    icon: Icons.person_outline,
                    title: 'Profil',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfilePage(
                            userId: userId,
                            nama: nama,
                            email: email,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // =====================================
            // BARIS MENU 3
            // =====================================

            Row(
              children: [
                Expanded(
                  child: _MenuCard(
                    icon: Icons.info_outline,
                    title: 'Tentang',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TentangPage(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 15),

                // Kotak kosong agar susunan tetap rapi
                const Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================
// MENU CARD
// =====================================

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 130,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 35,
              color: const Color(0xFF1976D2),
            ),

            const SizedBox(height: 10),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}