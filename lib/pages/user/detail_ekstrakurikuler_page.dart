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

  // Menampilkan foto dalam ukuran penuh
  void _lihatFoto(BuildContext context, String url, String keterangan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: const Text('Dokumentasi'),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.network(
                url,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.broken_image,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
          ),
          bottomNavigationBar: keterangan.isNotEmpty
              ? Container(
                  color: Colors.black,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    keterangan,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
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
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Detail Ekstrakurikuler'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ICON
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.groups_outlined,
                  size: 55,
                  color: Color(0xFF1976D2),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // NAMA EKSKUL
            Center(
              child: Text(
                nama,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // DESKRIPSI
            _judulBagian('Tentang Ekstrakurikuler'),

            const SizedBox(height: 12),

            _containerIsi(
              child: Text(
                deskripsi.trim().isEmpty
                    ? 'Belum ada deskripsi untuk ekstrakurikuler ini.'
                    : deskripsi,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // INFORMASI KEGIATAN
            _judulBagian('Informasi Kegiatan'),

            const SizedBox(height: 12),

            _InfoCard(
              icon: Icons.schedule,
              title: 'Jadwal',
              value: jadwal,
              emptyText: 'Belum ada jadwal',
            ),

            const SizedBox(height: 10),

            _InfoCard(
              icon: Icons.location_on_outlined,
              title: 'Lokasi',
              value: lokasi,
              emptyText: 'Belum ada lokasi',
            ),

            const SizedBox(height: 10),

            _InfoCard(
              icon: Icons.person_outline,
              title: 'Pembina',
              value: pembina,
              emptyText: 'Belum ada informasi pembina',
            ),

            const SizedBox(height: 30),

            // DOKUMENTASI
            _judulBagian('Dokumentasi'),

            const SizedBox(height: 5),

            const Text(
              'Foto kegiatan ekstrakurikuler',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 15),

            if (dokumentasi.isEmpty)
              _containerIsi(
                child: const Column(
                  children: [
                    Icon(
                      Icons.photo_library_outlined,
                      size: 50,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Belum ada dokumentasi',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dokumentasi.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final item = dokumentasi[index];

                  if (item is! Map) {
                    return const SizedBox.shrink();
                  }

                  final String gambar =
                      item['gambar']?.toString() ?? '';

                  final String keterangan =
                      item['keterangan']?.toString() ?? '';

                  // Gunakan alamat emulator Android.
                  // Foto tersimpan di uploads/ekskul/.
                  final String imageUrl =
                      'http://10.0.2.2/myekskul_api/uploads/ekskul/$gambar';

                  if (gambar.isEmpty) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.broken_image_outlined,
                        color: Colors.grey,
                        size: 40,
                      ),
                    );
                  }

                  return GestureDetector(
                    onTap: () => _lihatFoto(
                      context,
                      imageUrl,
                      keterangan,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;

                              return Container(
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorBuilder: (_, __, ___) {
                              return Container(
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.broken_image_outlined,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                          if (keterangan.isNotEmpty)
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                color: Colors.black54,
                                child: Text(
                                  keterangan,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          const Positioned(
                            top: 8,
                            right: 8,
                            child: Icon(
                              Icons.zoom_in,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 25),

            // INFORMASI TAMBAHAN
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Color(0xFF1976D2),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Informasi lebih lanjut mengenai kegiatan '
                      'dan pendaftaran ekstrakurikuler dapat '
                      'diperoleh melalui pihak sekolah.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _judulBagian(String judul) {
    return Text(
      judul,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _containerIsi({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.10),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
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
    final String isi = value.trim().isEmpty ? emptyText : value;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF1976D2),
            size: 25,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isi,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
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

