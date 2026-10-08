import 'package:flutter/material.dart';

import 'admin_ekskul_page.dart';
import 'admin_pertanyaan_page.dart';
import 'admin_users_page.dart';
import 'admin_profile_page.dart';
class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard Admin',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Kelola data dan sistem MyEkskul.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 25),

            // Statistik
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    icon: Icons.people_alt_outlined,
                    title: 'Pengguna',
                    value: '120',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    icon: Icons.groups_outlined,
                    title: 'Ekskul',
                    value: '12',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _statCard(
                    icon: Icons.quiz_outlined,
                    title: 'Pertanyaan',
                    value: '20',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    icon: Icons.recommend_outlined,
                    title: 'Rekomendasi',
                    value: '85',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Menu Admin',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _adminMenu(
  icon: Icons.groups_outlined,
  title: 'Kelola Ekstrakurikuler',
  subtitle: 'Tambah, edit, dan hapus data ekskul',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AdminEkskulPage(),
      ),
    );
  },
),

            _adminMenu(
  icon: Icons.quiz_outlined,
  title: 'Kelola Pertanyaan',
  subtitle: 'Kelola pertanyaan kuesioner',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AdminPertanyaanPage(),
      ),
    );
  },
),

            _adminMenu(
              icon: Icons.people_outline,
              title: 'Kelola Pengguna',
              subtitle: 'Melihat dan mengelola data pengguna',
              onTap: () {},
            ),

            _adminMenu(
              icon: Icons.person_outline,
              title: 'Profil Admin',
              subtitle: 'Informasi akun administrator',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF1976D2),
            size: 30,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _adminMenu({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF1976D2),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}