
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'detail_ekstrakurikuler_page.dart';

class EkstrakurikulerPage extends StatefulWidget {
  const EkstrakurikulerPage({super.key});

  @override
  State<EkstrakurikulerPage> createState() =>
      _EkstrakurikulerPageState();
}

class _EkstrakurikulerPageState
    extends State<EkstrakurikulerPage> {
  static const Color teal = Color(0xFF0F766E);
  static const Color tealDark = Color(0xFF115E59);
  static const Color background = Color(0xFFF4F7F7);

  static const String apiUrl =
      'http://10.0.2.2/myekskul_api/ekskul/get.php';

  final TextEditingController _searchController =
      TextEditingController();

  List<dynamic> ekskulList = [];
  bool isLoading = true;
  String? errorMessage;
  String kataKunci = '';

  @override
  void initState() {
    super.initState();
    ambilEkskul();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> ambilEkskul() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      final response = await http
          .get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 15));

      final dynamic hasil = jsonDecode(response.body);

      if (response.statusCode != 200 ||
          hasil is! Map ||
          hasil['success'] != true ||
          hasil['data'] is! List) {
        throw Exception(
          hasil is Map
              ? hasil['message'] ??
                  'Gagal mengambil data ekstrakurikuler.'
              : 'Respons server tidak valid.',
        );
      }

      if (!mounted) return;

      setState(() {
        ekskulList = List<dynamic>.from(hasil['data']);
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      debugPrint('Gagal mengambil ekskul: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage =
            'Data belum dapat dimuat. Periksa koneksi '
            'dan server, lalu coba lagi.';
      });
    }
  }

  List<dynamic> get ekskulTersaring {
    final query = kataKunci.trim().toLowerCase();

    if (query.isEmpty) return ekskulList;

    return ekskulList.where((item) {
      if (item is! Map) return false;

      final nama =
          (item['nama'] ?? '').toString().toLowerCase();
      final deskripsi =
          (item['deskripsi'] ?? '').toString().toLowerCase();
      final lokasi =
          (item['lokasi'] ?? '').toString().toLowerCase();

      return nama.contains(query) ||
          deskripsi.contains(query) ||
          lokasi.contains(query);
    }).toList();
  }

  String _teks(dynamic value, [String fallback = '']) {
    if (value == null) return fallback;
    return value.toString();
  }

  List<dynamic> _dokumentasi(dynamic value) {
    if (value is List) return value;

    if (value is String && value.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is List) return decoded;
      } catch (_) {
        // Data dokumentasi tidak valid.
      }
    }

    return [];
  }

  void tampilkanPesan(String pesan) {
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

  void bukaDetail(Map<String, dynamic> ekskul) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => DetailEkstrakurikulerPage(
          nama: _teks(ekskul['nama'], 'Ekstrakurikuler'),
          deskripsi: _teks(ekskul['deskripsi']),
          jadwal: _teks(ekskul['jadwal']),
          lokasi: _teks(ekskul['lokasi']),
          pembina: _teks(ekskul['pembina']),
          dokumentasi: _dokumentasi(ekskul['dokumentasi']),
        ),
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
        title: const Text(
          'Ekstrakurikuler',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: isLoading
          ? _buildLoading()
          : errorMessage != null
              ? _buildError()
              : _buildContent(),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: teal),
          SizedBox(height: 14),
          Text(
            'Memuat ekstrakurikuler...',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final daftar = ekskulTersaring;

    return RefreshIndicator(
      color: teal,
      onRefresh: ambilEkskul,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          _buildHeader(),
          const SizedBox(height: 18),
          TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() => kataKunci = value);
            },
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Cari nama atau deskripsi ekskul...',
              hintStyle: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: teal,
              ),
              suffixIcon: kataKunci.isNotEmpty
                  ? IconButton(
                      tooltip: 'Hapus pencarian',
                      onPressed: () {
                        _searchController.clear();
                        setState(() => kataKunci = '');
                      },
                      icon: const Icon(Icons.close_rounded),
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFFE2EAE8),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: teal,
                  width: 1.4,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Daftar Ekstrakurikuler',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF203331),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDDF3EF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${daftar.length} ekskul',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: teal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (daftar.isEmpty)
            _buildEmpty()
          else
            ...daftar.map((rawItem) {
              if (rawItem is! Map) {
                return const SizedBox.shrink();
              }

              final item = Map<String, dynamic>.from(rawItem);

              return _buildEkskulCard(item);
            }),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Tekan kartu untuk melihat detail kegiatan',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 11,
              ),
            ),
          ),
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
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Icon(
              Icons.groups_rounded,
              size: 76,
              color: Colors.white.withOpacity(0.10),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'TEMUKAN MINATMU',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Jelajahi Ekskul Favoritmu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'Temukan kegiatan yang sesuai dengan '
                'bakat, minat, dan potensimu.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.88),
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEkskulCard(Map<String, dynamic> ekskul) {
    final String nama =
        _teks(ekskul['nama'], 'Ekstrakurikuler');
    final String deskripsi = _teks(ekskul['deskripsi']);
    final String jadwal = _teks(ekskul['jadwal']);
    final String lokasi = _teks(ekskul['lokasi']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5ECEB)),
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
          onTap: () => bukaDetail(ekskul),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDF3EF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.groups_outlined,
                    color: teal,
                    size: 27,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nama,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.3,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF203331),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        deskripsi.trim().isEmpty
                            ? 'Belum ada deskripsi'
                            : deskripsi,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.45,
                          color: Color(0xFF64736F),
                        ),
                      ),
                      if (jadwal.trim().isNotEmpty) ...[
                        const SizedBox(height: 9),
                        _infoRingkas(
                          Icons.schedule_rounded,
                          jadwal,
                        ),
                      ],
                      if (lokasi.trim().isNotEmpty) ...[
                        const SizedBox(height: 5),
                        _infoRingkas(
                          Icons.location_on_outlined,
                          lokasi,
                        ),
                      ],
                      const SizedBox(height: 10),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Lihat detail',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: teal,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: teal,
                            size: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRingkas(IconData icon, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: teal),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF64736F),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 30,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            color: teal,
            size: 44,
          ),
          const SizedBox(height: 12),
          Text(
            kataKunci.isEmpty
                ? 'Belum ada ekstrakurikuler'
                : 'Ekskul tidak ditemukan',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF203331),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            kataKunci.isEmpty
                ? 'Data ekstrakurikuler belum tersedia.'
                : 'Coba gunakan kata kunci yang lain.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
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
            const SizedBox(height: 14),
            const Text(
              'Gagal Memuat Ekskul',
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
              onPressed: ambilEkskul,
              icon: const Icon(Icons.refresh_rounded),
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
}
