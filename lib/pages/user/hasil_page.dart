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
    try {
      final response = await http.get(
        Uri.parse(
          'http://10.0.2.2/myekskul_api/rekomendasi/get.php'
          '?user_id=${widget.userId}',
        ),
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (data['success'] == true) {
        setState(() {
          rekomendasi = data['data'] ?? [];
          isLoading = false;
          errorMessage = null;
        });
      } else {
        setState(() {
          errorMessage =
              data['message'] ?? 'Gagal mengambil rekomendasi';
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Tidak dapat terhubung ke server';
        isLoading = false;
      });
    }
  }

  // ============================================================
  // TAMPILAN UTAMA
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Rekomendasi'),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  // ============================================================
  // BODY
  // ============================================================

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.info_outline,
                size: 60,
                color: Colors.grey,
              ),

              const SizedBox(height: 16),

              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    errorMessage = null;
                  });

                  fetchRekomendasi();
                },
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (rekomendasi.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada hasil rekomendasi.',
          style: TextStyle(
            fontSize: 17,
            color: Colors.grey,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: fetchRekomendasi,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ======================================================
          // HEADER
          // ======================================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.emoji_events_rounded,
                  size: 55,
                  color: Color(0xFF1976D2),
                ),

                SizedBox(height: 15),

                Text(
                  'Hasil Rekomendasi Kamu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1976D2),
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  'Berikut hasil perhitungan berdasarkan jawaban kuesioner kamu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Rekomendasi Ekskul',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          // ======================================================
          // DAFTAR REKOMENDASI
          // ======================================================

          ...rekomendasi.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            final String namaEkskul =
                item['ekskul']?.toString() ?? '-';

            final String deskripsi =
                item['deskripsi']?.toString() ?? '';

            final String kategori =
                item['kategori']?.toString() ?? '-';

            final double skor =
                double.tryParse(
                      item['skor'].toString(),
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

          const SizedBox(height: 20),

          // ======================================================
          // TOMBOL KEMBALI
          // ======================================================

          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1976D2),
                side: const BorderSide(
                  color: Color(0xFF1976D2),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Kembali ke Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ============================================================
  // CARD REKOMENDASI
  // ============================================================

  Widget _buildRecommendationCard({
    required int peringkat,
    required String namaEkskul,
    required String deskripsi,
    required String kategori,
    required double skor,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====================================================
          // NOMOR PERINGKAT
          // ====================================================

          Container(
            width: 45,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$peringkat',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 15),

          // ====================================================
          // INFORMASI EKSKUL
          // ====================================================

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  namaEkskul,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    const Icon(
                      Icons.category_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),

                    const SizedBox(width: 5),

                    Text(
                      kategori,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                if (deskripsi.isNotEmpty) ...[
                  const SizedBox(height: 8),

                  Text(
                    deskripsi,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                // ==================================================
                // SKOR KECOCOKAN
                // ==================================================

                Row(
                  children: [
                    const Text(
                      'Kecocokan: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),

                    Text(
                      '${skor.toStringAsFixed(2)}%',
                      style: const TextStyle(
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 7),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (skor / 100).clamp(0.0, 1.0),
                    minHeight: 8,
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