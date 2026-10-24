
import 'package:flutter/material.dart';

class AdminPertanyaanPage extends StatefulWidget {
  const AdminPertanyaanPage({super.key});

  @override
  State<AdminPertanyaanPage> createState() =>
      _AdminPertanyaanPageState();
}

class _AdminPertanyaanPageState
    extends State<AdminPertanyaanPage> {
  static const Color primaryColor = Color(0xFF0F766E);
  static const Color secondaryColor = Color(0xFF14A098);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color textColor = Color(0xFF172033);
  static const Color mutedColor = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE7EBF1);
  static const Color softTeal = Color(0xFFE0F2F1);

  final TextEditingController searchController =
      TextEditingController();

  final List<String> kategoriList = [
    'Kedisiplinan',
    'Kerja Sama',
    'Kepemimpinan',
    'Tanggung Jawab',
  ];

  List<Map<String, dynamic>> pertanyaanList = [
    {
      'pertanyaan':
          'Apakah anggota hadir tepat waktu dalam setiap kegiatan ekskul?',
      'kategori': 'Kedisiplinan',
      'bobot': 1.0,
    },
    {
      'pertanyaan':
          'Apakah anggota mampu bekerja sama dengan anggota lainnya?',
      'kategori': 'Kerja Sama',
      'bobot': 2.0,
    },
    {
      'pertanyaan':
          'Apakah anggota menunjukkan tanggung jawab terhadap tugasnya?',
      'kategori': 'Tanggung Jawab',
      'bobot': 1.5,
    },
    {
      'pertanyaan':
          'Apakah anggota berinisiatif membantu jalannya kegiatan?',
      'kategori': 'Kepemimpinan',
      'bobot': 1.0,
    },
  ];

  List<Map<String, dynamic>> get pertanyaanTerfilter {
    final keyword = searchController.text.toLowerCase().trim();

    if (keyword.isEmpty) return pertanyaanList;

    return pertanyaanList.where((item) {
      return item['pertanyaan']
              .toString()
              .toLowerCase()
              .contains(keyword) ||
          item['kategori']
              .toString()
              .toLowerCase()
              .contains(keyword);
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        behavior: SnackBarBehavior.floating,
        backgroundColor: primaryColor,
      ),
    );
  }

  void bukaFormTambah() {
    final pertanyaanController = TextEditingController();
    final bobotController = TextEditingController(text: '1');
    String? kategoriTerpilih;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              title: const Text(
                'Tambah Pertanyaan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 420,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: pertanyaanController,
                        maxLines: 4,
                        decoration: inputDecoration(
                          'Pertanyaan',
                          hint: 'Masukkan pertanyaan kuesioner',
                          icon: Icons.help_outline_rounded,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: kategoriTerpilih,
                        isExpanded: true,
                        decoration: inputDecoration(
                          'Kategori',
                          icon: Icons.category_outlined,
                        ),
                        items: kategoriList.map((kategori) {
                          return DropdownMenuItem<String>(
                            value: kategori,
                            child: Text(kategori),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            kategoriTerpilih = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: bobotController,
                        keyboardType:
                            const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: inputDecoration(
                          'Bobot',
                          hint: 'Contoh: 1',
                          icon: Icons.scale_outlined,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(
                24, 0, 24, 20,
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.pop(dialogContext),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: mutedColor),
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final teks =
                        pertanyaanController.text.trim();
                    final bobot = double.tryParse(
                      bobotController.text.trim().replaceAll(',', '.'),
                    );

                    if (teks.isEmpty) {
                      tampilkanPesan('Pertanyaan wajib diisi');
                      return;
                    }

                    if (kategoriTerpilih == null) {
                      tampilkanPesan('Pilih kategori terlebih dahulu');
                      return;
                    }

                    if (bobot == null || bobot <= 0) {
                      tampilkanPesan(
                        'Bobot harus berupa angka lebih dari 0',
                      );
                      return;
                    }

                    setState(() {
                      pertanyaanList.insert(0, {
                        'pertanyaan': teks,
                        'kategori': kategoriTerpilih!,
                        'bobot': bobot,
                      });
                    });

                    Navigator.pop(dialogContext);
                    pertanyaanController.dispose();
                    bobotController.dispose();
                    tampilkanPesan(
                      'Pertanyaan berhasil ditambahkan (data lokal)',
                    );
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      pertanyaanController.dispose();
      bobotController.dispose();
    });
  }

  void bukaFormEdit(int index) {
    final item = pertanyaanTerfilter[index];
    final pertanyaanController = TextEditingController(
      text: item['pertanyaan'].toString(),
    );
    final bobotController = TextEditingController(
      text: item['bobot'].toString(),
    );
    String? kategoriTerpilih = item['kategori'].toString();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              title: const Text(
                'Edit Pertanyaan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 420,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: pertanyaanController,
                        maxLines: 4,
                        decoration: inputDecoration(
                          'Pertanyaan',
                          icon: Icons.help_outline_rounded,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: kategoriTerpilih,
                        isExpanded: true,
                        decoration: inputDecoration(
                          'Kategori',
                          icon: Icons.category_outlined,
                        ),
                        items: kategoriList.map((kategori) {
                          return DropdownMenuItem<String>(
                            value: kategori,
                            child: Text(kategori),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            kategoriTerpilih = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: bobotController,
                        keyboardType:
                            const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: inputDecoration(
                          'Bobot',
                          icon: Icons.scale_outlined,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    final teks =
                        pertanyaanController.text.trim();
                    final bobot = double.tryParse(
                      bobotController.text.trim().replaceAll(',', '.'),
                    );

                    if (teks.isEmpty ||
                        kategoriTerpilih == null ||
                        bobot == null ||
                        bobot <= 0) {
                      tampilkanPesan(
                        'Periksa kembali data pertanyaan',
                      );
                      return;
                    }

                    setState(() {
                      final posisi =
                          pertanyaanList.indexOf(item);
                      if (posisi != -1) {
                        pertanyaanList[posisi] = {
                          'pertanyaan': teks,
                          'kategori': kategoriTerpilih!,
                          'bobot': bobot,
                        };
                      }
                    });

                    Navigator.pop(dialogContext);
                    pertanyaanController.dispose();
                    bobotController.dispose();
                    tampilkanPesan('Pertanyaan diperbarui (data lokal)');
                  },
                  child: const Text('Simpan Perubahan'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      pertanyaanController.dispose();
      bobotController.dispose();
    });
  }

  void konfirmasiHapus(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Hapus Pertanyaan?'),
          content: const Text(
            'Pertanyaan ini akan dihapus dari daftar lokal.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Batal',
                style: TextStyle(color: mutedColor),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
              ),
              onPressed: () {
                setState(() {
                  pertanyaanList.remove(item);
                });
                Navigator.pop(dialogContext);
                tampilkanPesan('Pertanyaan dihapus dari data lokal');
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  InputDecoration inputDecoration(
    String label, {
    String? hint,
    IconData? icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon == null ? null : Icon(icon),
      filled: true,
      fillColor: backgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final daftar = pertanyaanTerfilter;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Kelola Pertanyaan',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: bukaFormTambah,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 3,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Atur pertanyaan kuesioner',
                    style: TextStyle(
                      color: mutedColor,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.quiz_outlined,
                          label: 'Total Pertanyaan',
                          value: '${pertanyaanList.length}',
                          color: primaryColor,
                          background: softTeal,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.category_outlined,
                          label: 'Kategori',
                          value: '${kategoriList.length}',
                          color: const Color(0xFF2563EB),
                          background: const Color(0xFFEFF6FF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Cari pertanyaan atau kategori...',
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: mutedColor,
                      ),
                      suffixIcon: searchController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                searchController.clear();
                                setState(() {});
                              },
                              icon: const Icon(Icons.close_rounded),
                            ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: borderColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: borderColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: primaryColor,
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
                          'Daftar Pertanyaan',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                      Text(
                        '${daftar.length} item',
                        style: const TextStyle(
                          color: mutedColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            Expanded(
              child: daftar.isEmpty
                  ? _EmptyState(
                      onAdd: bukaFormTambah,
                      isSearching: searchController.text.isNotEmpty,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        20, 0, 20, 100,
                      ),
                      itemCount: daftar.length,
                      itemBuilder: (context, index) {
                        final item = daftar[index];

                        return _QuestionCard(
                          nomor: index + 1,
                          pertanyaan:
                              item['pertanyaan'].toString(),
                          kategori: item['kategori'].toString(),
                          bobot: item['bobot'].toString(),
                          onEdit: () => bukaFormEdit(index),
                          onDelete: () => konfirmasiHapus(item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7EBF1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(height: 13),
          Text(
            value,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172033),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.nomor,
    required this.pertanyaan,
    required this.kategori,
    required this.bobot,
    required this.onEdit,
    required this.onDelete,
  });

  final int nomor;
  final String pertanyaan;
  final String kategori;
  final String bobot;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7EBF1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$nomor',
                  style: const TextStyle(
                    color: Color(0xFF0F766E),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  pertanyaan,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF172033),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Pilihan pertanyaan',
                icon: const Icon(
                  Icons.more_horiz_rounded,
                  color: Color(0xFF64748B),
                ),
                onSelected: (value) {
                  if (value == 'edit') onEdit();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 19),
                        SizedBox(width: 10),
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
                          color: Color(0xFFDC2626),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Hapus',
                          style: TextStyle(
                            color: Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(height: 1, color: Color(0xFFE7EBF1)),
          const SizedBox(height: 13),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                icon: Icons.category_outlined,
                label: kategori,
                color: const Color(0xFF0F766E),
                background: const Color(0xFFE0F2F1),
              ),
              _InfoChip(
                icon: Icons.scale_outlined,
                label: 'Bobot $bobot',
                color: const Color(0xFF475569),
                background: const Color(0xFFF1F5F9),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.onAdd,
    required this.isSearching,
  });

  final VoidCallback onAdd;
  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.quiz_outlined,
                size: 36,
                color: Color(0xFF0F766E),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              isSearching
                  ? 'Pertanyaan tidak ditemukan'
                  : 'Belum ada pertanyaan',
              style: const TextStyle(
                color: Color(0xFF172033),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              isSearching
                  ? 'Coba gunakan kata kunci lain.'
                  : 'Tambahkan pertanyaan pertama untuk memulai.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            if (!isSearching) ...[
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Tambah Pertanyaan'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0F766E),
                  side: const BorderSide(
                    color: Color(0xFF0F766E),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
