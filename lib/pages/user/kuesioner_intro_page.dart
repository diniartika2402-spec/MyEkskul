
import 'package:flutter/material.dart';
import 'kuesioner_page.dart';

class KuesionerIntroPage extends StatelessWidget {
  final int userId;

  const KuesionerIntroPage({
    super.key,
    required this.userId,
  });

  static const Color primary = Color(0xFF0F766E);
  static const Color background = Color(0xFFF7F9FC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        foregroundColor: const Color(0xFF172033),
        title: const Text(
          'Kuesioner Minat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              Center(
                child: Container(
                  width: 155,
                  height: 155,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2F1),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: const Icon(
                    Icons.assignment_rounded,
                    size: 85,
                    color: primary,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              const Text(
                'Kenali Minat dan Bakatmu!',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF172033),
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Jawab beberapa pertanyaan untuk '
                'mengetahui kegiatan ekstrakurikuler '
                'yang paling sesuai dengan minat dan '
                'potensi dirimu.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  height: 1.7,
                ),
              ),

              const SizedBox(height: 25),

              _infoItem(
                Icons.schedule_rounded,
                'Waktu pengisian',
                'Sekitar 5–10 menit',
              ),

              _infoItem(
                Icons.check_circle_outline_rounded,
                'Cara mengisi',
                'Pilih jawaban sesuai dirimu',
              ),

              _infoItem(
                Icons.auto_awesome_rounded,
                'Hasil kuesioner',
                'Rekomendasi ekskul sesuai minatmu',
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => KuesionerPage(
                          userId: userId,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Mulai Kuesioner',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward_rounded),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Center(
                child: Text(
                  'MyEkskul • Temukan Potensi Terbaikmu',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoItem(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: primary,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF172033),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
