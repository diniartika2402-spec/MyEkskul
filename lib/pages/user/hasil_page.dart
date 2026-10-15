
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HasilPage extends StatefulWidget {
  final int userId;

  const HasilPage({
    super.key,
    required this.userId,
  });

  @override
  State<HasilPage> createState() => _HasilPageState();
}

class _HasilPageState extends State<HasilPage> {
  static const Color teal = Color(0xFF0F766E);
  static const Color tealDark = Color(0xFF115E59);
  static const Color background = Color(0xFFF4F7F7);

  bool isLoading = true;
  String? errorMessage;
  List<dynamic> rekomendasi = [];

  @override
  void initState() {
    super.initState();
    fetchRekomendasi();
  }

  // ============================================================
  // MENGAMBIL REKOMENDASI DARI API
  // ============================================================

  Future<void> fetchRekomendasi() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      final response = await http
          .get(
            Uri.parse(
              'http://10.0.2.2/myekskul_api/rekomendasi/get.php'
              '?user_id=${widget.userId}',
            ),
          )
          .timeout(const Duration(seconds: 15));

      final dynamic data = jsonDecode(response.body);

      if (response.statusCode != 200 ||
          data is! Map ||
          data['success'] != true) {
        throw Exception(
          data is Map
              ? data['message'] ?? 'Gagal mengambil rekomendasi.'
              : 'Respons server tidak valid.',
        );
      }

      final dynamic result = data['data'];

      if (!mounted) return;

      setState(() {
        rekomendasi = result is List ? result : [];
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      debugPrint('Gagal mengambil rekomendasi: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage =
            'Hasil rekomendasi belum dapat dimuat. '
            'Periksa koneksi dan server, lalu coba lagi.';
      });
    }
  }

  // ============================================================
  // TAMPILAN UTAMA
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: teal,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 52,
        title: const Text(
          'Hasil Rekomendasi',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: teal),
            SizedBox(height: 14),
            Text(
              'Menyiapkan hasil rekomendasi...',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return _buildError();
    }

    if (rekomendasi.isEmpty) {
      return _buildEmpty();
    }

    return RefreshIndicator(
      color: teal,
      onRefresh: fetchRekomendasi,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          _buildHeader(),
          const SizedBox(height: 20),

          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDF3EF),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: teal,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rekomendasi Ekskul',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF203331),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Pilihan berdasarkan hasil kuesioner kamu',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F3F0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${rekomendasi.length} hasil',
                  style: const TextStyle(
                    color: teal,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ...rekomendasi.asMap().entries.map((entry) {
            final index = entry.key;
            final dynamic rawItem = entry.value;

            final Map<String, dynamic> item =
                rawItem is Map
                    ? Map<String, dynamic>.from(rawItem)
                    : <String, dynamic>{};

            final String namaEkskul =
                item['ekskul']?.toString() ?? '-';

            final String deskripsi =
                item['deskripsi']?.toString() ?? '';

            final String kategori =
                item['kategori']?.toString() ?? '-';

            final double skor = double.tryParse(
                  item['skor']?.toString() ?? '',
                ) ??
                0;

            return _buildRecommendationCard(
              peringkat: index + 1,
              namaEkskul: namaEkskul,
              deskripsi: deskripsi,
              kategori: kategori,
              skor: skor,
            );
          }),

          const SizedBox(height: 8),
          _buildBackButton(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [teal, tealDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: teal.withOpacity(0.16),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -8,
            top: -12,
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 90,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Kuesioner selesai',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 13),
              const Text(
                'Kenali Potensi,\nTemukan Minatmu!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'Berikut pilihan ekstrakurikuler yang '
                'direkomendasikan untuk kamu.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.88),
                  fontSize: 12,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // KARTU REKOMENDASI
  // ============================================================

  Widget _buildRecommendationCard({
    required int peringkat,
    required String namaEkskul,
    required String deskripsi,
    required String kategori,
    required double skor,
  }) {
    final double progress = (skor / 100).clamp(0.0, 1.0);

    final Color rankColor = peringkat == 1
        ? const Color(0xFFB7791F)
        : teal;

    final Color rankBackground = peringkat == 1
        ? const Color(0xFFFFF3D8)
        : const Color(0xFFE3F3F0);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: peringkat == 1
              ? const Color(0xFFF0D9A6)
              : const Color(0xFFE5ECEB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 43,
                height: 43,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: rankBackground,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: peringkat == 1
                    ? Icon(
                        Icons.emoji_events_rounded,
                        color: rankColor,
                        size: 25,
                      )
                    : Text(
                        '$peringkat',
                        style: TextStyle(
                          color: rankColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (peringkat == 1)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          'REKOMENDASI UTAMA',
                          style: TextStyle(
                            color: rankColor,
                            fontSize: 9,
                            letterSpacing: 0.6,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    Text(
                      namaEkskul,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.25,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF203331),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F5F4),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        kategori,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF526560),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (deskripsi.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              deskripsi,
              style: const TextStyle(
                fontSize: 12,
                height: 1.45,
                color: Color(0xFF64736F),
              ),
            ),
          ],

          const SizedBox(height: 14),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Expanded(
                child: Text(
                  'Skor kecocokan',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64736F),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${skor.toStringAsFixed(2)}%',
                style: const TextStyle(
                  color: teal,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: const Color(0xFFE7EFED),
              color: teal,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TAMPILAN ERROR
  // ============================================================

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: const BoxDecoration(
                color: Color(0xFFE3F3F0),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                color: teal,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum bisa memuat hasil',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF203331),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage ?? 'Terjadi kesalahan.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                height: 1.5,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: fetchRekomendasi,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TAMPILAN HASIL KOSONG
  // ============================================================

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: const BoxDecoration(
                color: Color(0xFFE3F3F0),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 36,
                color: teal,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum Ada Rekomendasi',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF203331),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Coba periksa kembali jawaban kuesioner '
              'atau muat ulang hasilnya.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: fetchRekomendasi,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Muat Ulang'),
              style: OutlinedButton.styleFrom(
                foregroundColor: teal,
                side: const BorderSide(color: teal),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Kembali ke Dashboard',
                style: TextStyle(color: teal),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TOMBOL KEMBALI
  // ============================================================

  Widget _buildBackButton() {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton.icon(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_rounded,
          size: 17,
        ),
        label: const Text(
          'Kembali ke Dashboard',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: teal,
          side: const BorderSide(color: teal),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
