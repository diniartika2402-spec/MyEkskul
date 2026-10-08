import 'package:flutter/material.dart';

class TentangPage extends StatelessWidget {
  const TentangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang MyEkskul'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.school_rounded,
                color: Colors.white,
                size: 60,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'MyEkskul',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Aplikasi Rekomendasi Ekstrakurikuler',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            // Tentang aplikasi
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tentang Aplikasi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'MyEkskul merupakan aplikasi yang membantu '
                      'siswa menemukan rekomendasi ekstrakurikuler '
                      'berdasarkan minat dan ketertarikan mereka.',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Cara kerja
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cara Kerja',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    _InfoItem(
                      icon: Icons.edit_note,
                      text: 'Isi kuesioner mengenai minat kamu.',
                    ),

                    _InfoItem(
                      icon: Icons.calculate_outlined,
                      text: 'Sistem mengolah jawaban kamu.',
                    ),

                    _InfoItem(
                      icon: Icons.recommend_outlined,
                      text: 'Sistem menampilkan rekomendasi ekstrakurikuler.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Versi
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.info_outline,
                  color: Color(0xFF1976D2),
                ),
                title: const Text('Versi Aplikasi'),
                subtitle: const Text('MyEkskul v1.0.0'),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              '© 2026 MyEkskul',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// =====================================
// INFO ITEM
// =====================================

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF1976D2),
            size: 24,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}