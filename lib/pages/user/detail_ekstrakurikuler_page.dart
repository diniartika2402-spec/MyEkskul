
import 'package:flutter/material.dart';

class DetailEkstrakurikulerPage extends StatelessWidget {
  final String nama;
  final String deskripsi;
  final String jadwal;
  final String lokasi;
  final String pembina;
  final List<dynamic> dokumentasi;

  const DetailEkstrakurikulerPage({
    super.key,
    required this.nama,
    required this.deskripsi,
    required this.jadwal,
    required this.lokasi,
    required this.pembina,
    required this.dokumentasi,
  });

  static const Color primary = Color(0xFF0F766E);
  static const Color primaryDark = Color(0xFF115E59);
  static const Color background = Color(0xFFF4F7F8);

  void _lihatFoto(
    BuildContext context,
    String url,
    String keterangan,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0,
            title: const Text('Dokumentasi'),
          ),
          body: Center(
            child: InteractiveViewer(
              minScale: 0.7,
              maxScale: 4,
              child: Image.network(
                url,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.broken_image_outlined,
                  color: Colors.white70,
                  size: 64,
                ),
              ),
            ),
          ),
          bottomNavigationBar: keterangan.trim().isNotEmpty
              ? SafeArea(
                  child: Container(
                    color: Colors.black,
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    child: Text(
                      keterangan,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Detail Ekstrakurikuler',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHero(),
              const SizedBox(height: 28),

              _judulBagian(
                'Tentang Ekstrakurikuler',
                Icons.info_outline_rounded,
              ),
              const SizedBox(height: 12),
              _containerIsi(
                child: Text(
                  deskripsi.trim().isEmpty
                      ? 'Belum ada deskripsi untuk ekstrakurikuler ini.'
                      : deskripsi.trim(),
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.7,
                    color: Color(0xFF475569),
                  ),
                ),
              ),

              const SizedBox(height: 26),

              _judulBagian(
                'Informasi Kegiatan',
                Icons.event_note_rounded,
              ),
              const SizedBox(height: 12),

              _InfoCard(
                icon: Icons.schedule_rounded,
                title: 'Jadwal Kegiatan',
                value: jadwal,
                emptyText: 'Belum ada jadwal',
              ),
              const SizedBox(height: 10),
              _InfoCard(
                icon: Icons.location_on_outlined,
                title: 'Lokasi',
                value: lokasi,
                emptyText: 'Belum ada informasi lokasi',
              ),
              const SizedBox(height: 10),
              _InfoCard(
                icon: Icons.person_outline_rounded,
                title: 'Pembina',
                value: pembina,
                emptyText: 'Belum ada informasi pembina',
              ),

              const SizedBox(height: 28),

              _judulBagian(
                'Dokumentasi',
                Icons.photo_library_outlined,
              ),
              const SizedBox(height: 5),
              const Text(
                'Momen kegiatan ekstrakurikuler',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 15),

              if (dokumentasi.isEmpty)
                _containerIsi(
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Column(
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          size: 48,
                          color: Color(0xFF94A3B8),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Belum ada dokumentasi',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                _buildGaleri(context),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFCCFBF1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF99F6E4),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      color: primaryDark,
                      size: 23,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Ingin mengetahui lebih lanjut tentang kegiatan '
                        'atau pendaftaran? Hubungi pihak sekolah untuk '
                        'mendapatkan informasi selengkapnya.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.6,
                          color: Color(0xFF134E4A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primary, primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
              ),
            ),
            child: const Icon(
              Icons.groups_rounded,
              size: 42,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            nama.trim().isEmpty ? 'Ekstrakurikuler' : nama.trim(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Kenali kegiatan dan informasi lengkapnya',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _judulBagian(String judul, IconData icon) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFCCFBF1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: primary, size: 21),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            judul,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172B3A),
            ),
          ),
        ),
      ],
    );
  }

  Widget _containerIsi({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE8EEF0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildGaleri(BuildContext context) {
    final items = dokumentasi.where((item) => item is Map).toList();

    if (items.isEmpty) {
      return _containerIsi(
        child: const Text(
          'Belum ada dokumentasi yang dapat ditampilkan.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF64748B)),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.88,
      ),
      itemBuilder: (context, index) {
        final item = items[index] as Map;
        final gambar = item['gambar']?.toString().trim() ?? '';
        final keterangan = item['keterangan']?.toString().trim() ?? '';

        if (gambar.isEmpty) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Center(
              child: Icon(
                Icons.broken_image_outlined,
                color: Color(0xFF64748B),
                size: 38,
              ),
            ),
          );
        }

        final imageUrl =
            'http://10.0.2.2/myekskul_api/uploads/ekskul/$gambar';

        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _lihatFoto(context, imageUrl, keterangan),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: const Color(0xFFE2E8F0),
                            child: const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: primary,
                                ),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFE2E8F0),
                          child: const Icon(
                            Icons.broken_image_outlined,
                            size: 38,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.45),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.zoom_in_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (keterangan.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 9,
                    ),
                    child: Text(
                      keterangan,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String emptyText;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    final isi = value.trim().isEmpty ? emptyText : value.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE8EEF0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFCCFBF1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: const Color(0xFF0F766E), size: 23),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  isi,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
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
