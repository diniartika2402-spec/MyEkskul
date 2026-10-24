
import 'package:flutter/material.dart';

class AdminEkskulPage extends StatefulWidget {
  const AdminEkskulPage({super.key});

  @override
  State<AdminEkskulPage> createState() => _AdminEkskulPageState();
}

class _AdminEkskulPageState extends State<AdminEkskulPage> {
  static const Color primaryColor = Color(0xFF0F766E);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color textColor = Color(0xFF172033);
  static const Color mutedColor = Color(0xFF64748B);

  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> ekskulList = [
    {
      'nama': 'Pramuka',
      'kategori': 'Organisasi',
      'deskripsi': 'Kegiatan kepemimpinan, kedisiplinan, dan kerja sama.',
    },
    {
      'nama': 'Futsal',
      'kategori': 'Olahraga',
      'deskripsi': 'Kegiatan olahraga dan pengembangan kemampuan bermain futsal.',
    },
    {
      'nama': 'IT Club',
      'kategori': 'Teknologi',
      'deskripsi': 'Kegiatan belajar teknologi informasi dan komputer.',
    },
  ];

  String _searchQuery = '';

  List<Map<String, String>> get _filteredEkskul {
    if (_searchQuery.trim().isEmpty) return ekskulList;

    final query = _searchQuery.toLowerCase().trim();

    return ekskulList.where((ekskul) {
      return (ekskul['nama'] ?? '').toLowerCase().contains(query) ||
          (ekskul['kategori'] ?? '').toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showEkskulForm({Map<String, String>? ekskul}) {
    final isEdit = ekskul != null;
    final namaController = TextEditingController(
      text: ekskul?['nama'] ?? '',
    );
    final kategoriController = TextEditingController(
      text: ekskul?['kategori'] ?? '',
    );
    final deskripsiController = TextEditingController(
      text: ekskul?['deskripsi'] ?? '',
    );

    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            isEdit ? 'Edit Ekskul' : 'Tambah Ekskul',
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _formField(
                      controller: namaController,
                      label: 'Nama Ekstrakurikuler',
                      hint: 'Contoh: Basket',
                      icon: Icons.groups_rounded,
                    ),
                    const SizedBox(height: 13),
                    _formField(
                      controller: kategoriController,
                      label: 'Kategori',
                      hint: 'Contoh: Olahraga',
                      icon: Icons.category_outlined,
                    ),
                    const SizedBox(height: 13),
                    _formField(
                      controller: deskripsiController,
                      label: 'Deskripsi',
                      hint: 'Jelaskan kegiatan ekstrakurikuler',
                      icon: Icons.description_outlined,
                      maxLines: 3,
                      required: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (!formKey.currentState!.validate()) return;

                final data = <String, String>{
                  'nama': namaController.text.trim(),
                  'kategori': kategoriController.text.trim(),
                  'deskripsi': deskripsiController.text.trim(),
                };

                setState(() {
                  if (isEdit) {
                    final index = ekskulList.indexOf(ekskul);
                    if (index != -1) {
                      ekskulList[index] = data;
                    }
                  } else {
                    ekskulList.add(data);
                  }
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEdit
                          ? 'Ekskul berhasil diperbarui.'
                          : 'Ekskul berhasil ditambahkan.',
                    ),
                    backgroundColor: primaryColor,
                  ),
                );
              },
              icon: Icon(
                isEdit ? Icons.save_outlined : Icons.add_rounded,
                size: 19,
              ),
              label: Text(isEdit ? 'Simpan' : 'Tambah'),
            ),
          ],
        );
      },
    ).whenComplete(() {
      namaController.dispose();
      kategoriController.dispose();
      deskripsiController.dispose();
    });
  }

  Widget _formField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    bool required = true,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      textCapitalization: TextCapitalization.sentences,
      validator: (value) {
        if (required && (value == null || value.trim().isEmpty)) {
          return '$label wajib diisi';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        alignLabelWithHint: maxLines > 1,
        filled: true,
        fillColor: backgroundColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }

  Future<void> _hapusEkskul(Map<String, String> ekskul) async {
    final nama = ekskul['nama'] ?? 'ekskul ini';

    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          icon: const Icon(
            Icons.delete_outline_rounded,
            size: 38,
            color: Colors.red,
          ),
          title: const Text(
            'Hapus Ekstrakurikuler?',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: Text(
            'Apakah kamu yakin ingin menghapus "$nama"?',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Ya, Hapus'),
            ),
          ],
        );
      },
    );

    if (konfirmasi != true || !mounted) return;

    setState(() {
      ekskulList.remove(ekskul);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$nama berhasil dihapus.'),
        backgroundColor: primaryColor,
      ),
    );
  }

  IconData _iconKategori(String kategori) {
    switch (kategori.toLowerCase()) {
      case 'olahraga':
        return Icons.sports_soccer_rounded;
      case 'teknologi':
        return Icons.computer_rounded;
      case 'organisasi':
        return Icons.flag_rounded;
      case 'seni':
        return Icons.palette_rounded;
      default:
        return Icons.groups_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredEkskul;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kelola Ekskul',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Data ekstrakurikuler sekolah',
              style: TextStyle(
                color: mutedColor,
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEkskulForm(),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 3,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          // Statistik ringkas
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: _summaryCard(
                    icon: Icons.groups_rounded,
                    label: 'Total Ekskul',
                    value: '${ekskulList.length}',
                    color: primaryColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _summaryCard(
                    icon: Icons.search_rounded,
                    label: 'Hasil Pencarian',
                    value: '${filteredList.length}',
                    color: const Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
          ),

          // Kolom pencarian
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
              decoration: InputDecoration(
                hintText: 'Cari nama atau kategori ekskul...',
                hintStyle: const TextStyle(
                  color: mutedColor,
                  fontSize: 13,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: mutedColor,
                ),
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Hapus pencarian',
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(color: primaryColor),
                ),
              ),
            ),
          ),

          // Daftar ekskul
          Expanded(
            child: filteredList.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.search_off_rounded,
                            size: 54,
                            color: Color(0xFF94A3B8),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Ekskul tidak ditemukan',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Coba gunakan kata kunci lain.',
                            style: TextStyle(
                              color: mutedColor,
                              fontSize: 12,
                            ),
                          ),
                          if (_searchQuery.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                              child: const Text('Hapus pencarian'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 2, 16, 90),
                    itemCount: filteredList.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 9),
                    itemBuilder: (context, index) {
                      final ekskul = filteredList[index];
                      final nama = ekskul['nama'] ?? '';
                      final kategori = ekskul['kategori'] ?? '';
                      final deskripsi = ekskul['deskripsi'] ?? '';

                      return Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFFE7EBF1),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 43,
                              height: 43,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2F1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _iconKategori(kategori),
                                color: primaryColor,
                                size: 23,
                              ),
                            ),
                            const SizedBox(width: 11),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nama,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE0F2F1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      kategori.isEmpty
                                          ? 'Tanpa kategori'
                                          : kategori,
                                      style: const TextStyle(
                                        color: primaryColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  if (deskripsi.isNotEmpty) ...[
                                    const SizedBox(height: 7),
                                    Text(
                                      deskripsi,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: mutedColor,
                                        fontSize: 12,
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: 4),
                            PopupMenuButton<String>(
                              tooltip: 'Aksi ekskul',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 150,
                              ),
                              icon: const Icon(
                                Icons.more_vert_rounded,
                                color: mutedColor,
                              ),
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _showEkskulForm(ekskul: ekskul);
                                } else if (value == 'delete') {
                                  _hapusEkskul(ekskul);
                                }
                              },
                              itemBuilder: (_) => const [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.edit_outlined,
                                        size: 19,
                                        color: primaryColor,
                                      ),
                                      SizedBox(width: 9),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outline_rounded,
                                        size: 19,
                                        color: Colors.red,
                                      ),
                                      SizedBox(width: 9),
                                      Text(
                                        'Hapus',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Icon(icon, size: 23, color: color),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: mutedColor,
                    fontSize: 10,
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
