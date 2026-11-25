
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
  static const Color textDark = Color(0xFF172033);
  static const Color muted = Color(0xFF64748B);
  static const Color softTeal = Color(0xFFE0F2F1);

  void _mulaiKuesioner(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KuesionerPage(
          userId: userId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        foregroundColor: textDark,
        title: const Text(
          'Kuesioner Minat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;

            // Menyesuaikan ukuran untuk layar pendek.
            final compact = height < 650;

            final horizontalPadding = compact ? 20.0 : 24.0;
            final imageSize = (height * 0.23).clamp(
              105.0,
              155.0,
            );

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: compact ? 8 : 14,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // =====================================
                  // ILUSTRASI
                  // =====================================

                  Expanded(
                    flex: 4,
                    child: Center(
                      child: Container(
                        width: imageSize,
                        height: imageSize,
                        decoration: BoxDecoration(
                          color: softTeal,
                          borderRadius: BorderRadius.circular(
                            compact ? 28 : 35,
                          ),
                        ),
                        child: Icon(
                          Icons.assignment_rounded,
                          size: imageSize * 0.55,
                          color: primary,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: compact ? 8 : 18),

                  // =====================================
                  // JUDUL
                  // =====================================

                  Text(
                    'Kenali Minat dan Bakatmu!',
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: compact ? 22 : 25,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                      height: 1.2,
                    ),
                  ),

                  SizedBox(height: compact ? 7 : 12),

                  // =====================================
                  // DESKRIPSI
                  // =====================================

                  Text(
                    'Jawab beberapa pertanyaan untuk '
                    'mengetahui kegiatan ekstrakurikuler '
                    'yang paling sesuai dengan minat dan '
                    'potensi dirimu.',
                    maxLines: compact ? 3 : 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: compact ? 12 : 14,
                      color: muted,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: compact ? 12 : 20),

                  // =====================================
                  // INFORMASI KUESIONER
                  // =====================================

                  _infoItem(
                    Icons.schedule_rounded,
                    'Waktu pengisian',
                    'Sekitar 5–10 menit',
                    compact,
                  ),

                  _infoItem(
                    Icons.check_circle_outline_rounded,
                    'Cara mengisi',
                    'Pilih jawaban sesuai dirimu',
                    compact,
                  ),

                  _infoItem(
                    Icons.auto_awesome_rounded,
                    'Hasil kuesioner',
                    'Rekomendasi ekskul sesuai minatmu',
                    compact,
                  ),

                  const Spacer(flex: 1),

                  // =====================================
                  // TOMBOL MULAI
                  // =====================================

                  SizedBox(
                    width: double.infinity,
                    height: compact ? 48 : 54,
                    child: ElevatedButton(
                      onPressed: () {
                        _mulaiKuesioner(context);
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: primary.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Mulai Kuesioner',
                            style: TextStyle(
                              fontSize: compact ? 14 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: compact ? 7 : 12),

                  // =====================================
                  // FOOTER
                  // =====================================

                  const Center(
                    child: Text(
                      'MyEkskul • Temukan Potensi Terbaikmu',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ),

                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // =====================================
  // WIDGET INFORMASI
  // =====================================

  Widget _infoItem(
    IconData icon,
    String title,
    String subtitle,
    bool compact,
  ) {
    final iconSize = compact ? 38.0 : 43.0;

    return Padding(
      padding: EdgeInsets.only(
        bottom: compact ? 8 : 13,
      ),

      child: Row(
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: softTeal,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: primary,
              size: compact ? 19 : 22,
            ),
          ),

          SizedBox(width: compact ? 11 : 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: compact ? 12 : 13,
                    color: textDark,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: compact ? 10 : 11,
                    color: muted,
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
