
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'detail_ekstrakurikuler_page.dart';

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

  static const String baseUrl = 'http://10.0.2.2/myekskul_api';

  bool isLoading = true;
  String? errorMessage;
  List<dynamic> rekomendasi = [];

  // Cache daftar ekskul agar tidak perlu memanggil API
  // berulang kali ketika pengguna membuka detail.
  List<dynamic>? daftarEkskul;

  @override
  void initState() {
    super.initState();
    fetchRekomendasi();
  }

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
              '$baseUrl/rekomendasi/get.php'
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

  // Mengambil daftar ekskul untuk mencari informasi detail.
  // Endpoint dan struktur JSON harus disesuaikan dengan API kamu.
  Future<List<dynamic>> _ambilDaftarEkskul() async {
    if (daftarEkskul != null) {
      return daftarEkskul!;
    }

    final response = await http
        .get(Uri.parse('$baseUrl/ekskul/get.php'))
        .timeout(const Duration(seconds: 15));

    final dynamic data = jsonDecode(response.body);

    if (response.statusCode != 200 ||
        data is! Map ||
        data['success'] != true ||
        data['data'] is! List) {
      throw Exception('Gagal mengambil detail ekstrakurikuler.');
    }

    daftarEkskul = List<dynamic>.from(data['data']);
    return daftarEkskul!;
  }

  String _teks(dynamic value, [String fallback = '']) {
    if (value == null) return fallback;
    return value.toString();
  }

  Future<void> _bukaDetail(
    Map<String, dynamic> rekomendasiItem,
  ) async {
    final String nama = _teks(rekomendasiItem['ekskul']).trim();

    if (nama.isEmpty || nama == '-') {
      _pesan('Nama ekstrakurikuler tidak tersedia.');
      return;
    }

    // Tampilkan indikator ketika data detail sedang dicari.
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: teal,
                  ),
                ),
                SizedBox(width: 14),
                Text('Membuka detail...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final List<dynamic> daftar = await _ambilDaftarEkskul();

      // Pencocokan nama ekskul tanpa membedakan huruf besar/kecil.
      Map<String, dynamic>? detail;

      for (final dynamic raw in daftar) {
        if (raw is! Map) continue;

        final item = Map<String, dynamic>.from(raw);

        // Sesuaikan 'nama' jika API daftar ekskul memakai
        // nama kolom yang berbeda, misalnya 'nama_ekskul'.
        final String namaData =
            _teks(item['nama'] ?? item['nama_ekskul']).trim();

        if (namaData.toLowerCase() == nama.toLowerCase()) {
          detail = item;
          break;
        }
      }

      if (!mounted) return;

      Navigator.of(context, rootNavigator: true).pop();

      if (detail == null) {
        _pesan(
          'Detail "$nama" tidak ditemukan. '
          'Pastikan nama ekskul pada kedua API sama.',
        );
        return;
      }

      // Dokumentasi dapat berupa List JSON atau String JSON.
      dynamic dokumentasiRaw = detail['dokumentasi'];

      if (dokumentasiRaw is String &&
          dokumentasiRaw.trim().isNotEmpty) {
        try {
          dokumentasiRaw = jsonDecode(dokumentasiRaw);
        } catch (_) {
          dokumentasiRaw = [];
        }
      }

      final List<dynamic> dokumentasi =
          dokumentasiRaw is List ? dokumentasiRaw : [];

      await Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => DetailEkstrakurikulerPage(
            nama: _teks(
              detail!['nama'] ?? detail['nama_ekskul'],
              nama,
            ),
            deskripsi: _teks(
              detail['deskripsi'] ??
                  rekomendasiItem['deskripsi'],
            ),
            jadwal: _teks(detail['jadwal']),
            lokasi: _teks(detail['lokasi']),
            pembina: _teks(detail['pembina']),
            dokumentasi: dokumentasi,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Gagal membuka detail ekskul: $e');

      if (!mounted) return;

      // Tutup dialog loading jika masih terbuka.
      Navigator.of(context, rootNavigator: true).pop();

      _pesan(
        'Tidak dapat membuka detail ekskul. '
        'Periksa endpoint API daftar ekstrakurikuler.',
      );
    }
  }

  void _pesan(String pesan) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(pesan),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

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

    if (errorMessage != null) return _buildError();
    if (rekomendasi.isEmpty) return _buildEmpty();

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
                      'Pilih kartu untuk melihat detail ekskul',
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
            final int index = entry.key;
            final dynamic rawItem = entry.value;

            final Map<String, dynamic> item = rawItem is Map
                ? Map<String, dynamic>.from(rawItem)
                : <String, dynamic>{};

            final String namaEkskul =
                _teks(item['ekskul'], '-');
            final String deskripsi =
                _teks(item['deskripsi']);
            final String kategori =
                _teks(item['kategori'], '-');
            final double skor = double.tryParse(
                  _teks(item['skor'], '0'),
                ) ??
                0;

            return _buildRecommendationCard(
              peringkat: index + 1,
              namaEkskul: namaEkskul,
              deskripsi: deskripsi,
              kategori: kategori,
              skor: skor,
              onTap: () => _bukaDetail(item),
            );
          }),

          const SizedBox(height: 8),
          _buildBackButton(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

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

  Widget _buildRecommendationCard({
    required int peringkat,
    required String namaEkskul,
    required String deskripsi,
    required String kategori,
    required double skor,
    required VoidCallback onTap,
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
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
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: teal,
                    ),
                  ],
                ),
                if (deskripsi.trim().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    deskripsi,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Lihat detail ekskul',
                      style: TextStyle(
                        fontSize: 11,
                        color: teal,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: teal,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: teal,
              size: 48,
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 58,
              color: teal,
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
              'Coba periksa jawaban kuesioner '
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
