
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminPertanyaanPage extends StatefulWidget {
  const AdminPertanyaanPage({super.key});

  @override
  State<AdminPertanyaanPage> createState() =>
      _AdminPertanyaanPageState();
}

class _AdminPertanyaanPageState
    extends State<AdminPertanyaanPage> {
  final String baseUrl = 'http://10.0.2.2/myekskul_api';

  List<dynamic> pertanyaanList = [];
  List<dynamic> kategoriList = [];

  bool isLoading = true;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    ambilData();
  }

  // =====================================================
  // MENGAMBIL DATA
  // =====================================================

  Future<void> ambilData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      final responses = await Future.wait([
        http.get(Uri.parse('$baseUrl/pertanyaan/get.php')),
        http.get(Uri.parse('$baseUrl/kategori/get.php')),
      ]);

      if (responses[0].statusCode != 200 ||
          responses[1].statusCode != 200) {
        throw Exception('Gagal terhubung ke server');
      }

      final dataPertanyaan = jsonDecode(responses[0].body);
      final dataKategori = jsonDecode(responses[1].body);

      if (dataPertanyaan['success'] != true ||
          dataKategori['success'] != true) {
        throw Exception('Gagal mengambil data');
      }

      if (!mounted) return;

      setState(() {
        pertanyaanList = dataPertanyaan['data'] ?? [];
        kategoriList = dataKategori['data'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      tampilkanPesan('Gagal mengambil data: $e');
    }
  }

  // =====================================================
  // SNACKBAR
  // =====================================================

  void tampilkanPesan(String pesan) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // =====================================================
  // TAMBAH PERTANYAAN
  // =====================================================

  Future<void> bukaFormTambah() async {
    await prosesForm();
  }

  // =====================================================
  // EDIT PERTANYAAN
  // =====================================================

  Future<void> bukaFormEdit(
    Map<String, dynamic> pertanyaan,
  ) async {
    await prosesForm(pertanyaan: pertanyaan);
  }

  // =====================================================
  // FORM DIALOG
  // =====================================================

  Future<void> prosesForm({
    Map<String, dynamic>? pertanyaan,
  }) async {
    if (kategoriList.isEmpty) {
      tampilkanPesan('Data kategori belum tersedia');
      return;
    }

    final bool modeEdit = pertanyaan != null;

    final hasil = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AdminPertanyaanFormDialog(
          kategoriList: kategoriList,
          pertanyaan: pertanyaan,
        );
      },
    );

    if (hasil == null || !mounted) return;

    final id = modeEdit
        ? int.tryParse(pertanyaan['id'].toString())
        : null;

    if (modeEdit && id == null) {
      tampilkanPesan('ID pertanyaan tidak valid');
      return;
    }

    if (!mounted) return;

    setState(() {
      isProcessing = true;
    });

    bool berhasil = false;

    if (modeEdit) {
      berhasil = await updatePertanyaan(
        id!,
        hasil['pertanyaan'],
        hasil['kategori_id'],
        hasil['bobot'],
      );
    } else {
      berhasil = await tambahPertanyaan(
        hasil['pertanyaan'],
        hasil['kategori_id'],
        hasil['bobot'],
      );
    }

    if (!mounted) return;

    setState(() {
      isProcessing = false;
    });

    if (berhasil) {
      tampilkanPesan(
        modeEdit
            ? 'Pertanyaan berhasil diperbarui'
            : 'Pertanyaan berhasil ditambahkan',
      );

      await ambilData();
    }
  }

  // =====================================================
  // TAMBAH API
  // =====================================================

  Future<bool> tambahPertanyaan(
    String teks,
    int kategoriId,
    double bobot,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pertanyaan/tambah.php'),
        body: {
          'pertanyaan': teks,
          'kategori_id': kategoriId.toString(),
          'bobot': bobot.toString(),
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data['success'] == true) {
        return true;
      }

      tampilkanPesan(
        data['message']?.toString() ??
            'Gagal menambahkan pertanyaan',
      );

      return false;
    } catch (e) {
      tampilkanPesan('Terjadi kesalahan: $e');
      return false;
    }
  }

  // =====================================================
  // UPDATE API
  // =====================================================

  Future<bool> updatePertanyaan(
    int id,
    String teks,
    int kategoriId,
    double bobot,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pertanyaan/update.php'),
        body: {
          'id': id.toString(),
          'pertanyaan': teks,
          'kategori_id': kategoriId.toString(),
          'bobot': bobot.toString(),
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data['success'] == true) {
        return true;
      }

      tampilkanPesan(
        data['message']?.toString() ??
            'Gagal memperbarui pertanyaan',
      );

      return false;
    } catch (e) {
      tampilkanPesan('Terjadi kesalahan: $e');
      return false;
    }
  }

  // =====================================================
  // HAPUS PERTANYAAN
  // =====================================================

  Future<void> hapusPertanyaan(
    int id,
    String teks,
  ) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text('Hapus Pertanyaan'),
          content: Text(
            'Apakah kamu yakin ingin menghapus pertanyaan ini?\n\n$teks',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (konfirmasi != true || !mounted) return;

    setState(() {
      isProcessing = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pertanyaan/hapus.php'),
        body: {
          'id': id.toString(),
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data['success'] == true) {
        tampilkanPesan('Pertanyaan berhasil dihapus');
        await ambilData();
      } else {
        tampilkanPesan(
          data['message']?.toString() ??
              'Gagal menghapus pertanyaan',
        );
      }
    } catch (e) {
      tampilkanPesan('Terjadi kesalahan: $e');
    } finally {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
      }
    }
  }

  // =====================================================
  // LABEL INFORMASI
  // =====================================================

  Widget labelInfo(IconData icon, String teks) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.blueGrey,
          ),
          const SizedBox(width: 5),
          Text(
            teks,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // KARTU PERTANYAAN
  // =====================================================

  Widget kartuPertanyaan(
    dynamic pertanyaan,
    int index,
  ) {
    final teks =
        pertanyaan['pertanyaan']?.toString() ?? '';

    final kategori =
        pertanyaan['kategori']?.toString() ?? '-';

    final bobot =
        pertanyaan['bobot']?.toString() ?? '1';

    final id = int.tryParse(
      pertanyaan['id'].toString(),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Color(0xFF1976D2),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    teks,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                labelInfo(
                  Icons.category_outlined,
                  kategori,
                ),
                labelInfo(
                  Icons.scale_outlined,
                  'Bobot: $bobot',
                ),
              ],
            ),
            const Divider(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: isProcessing
                      ? null
                      : () {
                          bukaFormEdit(
                            Map<String, dynamic>.from(
                              pertanyaan,
                            ),
                          );
                        },
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 17,
                  ),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1976D2),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: isProcessing || id == null
                      ? null
                      : () {
                          hapusPertanyaan(id, teks);
                        },
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 17,
                  ),
                  label: const Text('Hapus'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // TAMPILAN UTAMA
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Kelola Pertanyaan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1976D2),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isProcessing || kategoriList.isEmpty
            ? null
            : bukaFormTambah,
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Pertanyaan'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: ambilData,
              child: pertanyaanList.isEmpty
                  ? ListView(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 150),
                        Icon(
                          Icons.quiz_outlined,
                          size: 65,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 15),
                        Center(
                          child: Text(
                            'Belum ada pertanyaan',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        18,
                        20,
                        18,
                        90,
                      ),
                      itemCount: pertanyaanList.length,
                      itemBuilder: (context, index) {
                        return kartuPertanyaan(
                          pertanyaanList[index],
                          index,
                        );
                      },
                    ),
            ),
    );
  }
}

// =========================================================
// FORM TAMBAH DAN EDIT TERPISAH
// =========================================================

class AdminPertanyaanFormDialog extends StatefulWidget {
  final List<dynamic> kategoriList;
  final Map<String, dynamic>? pertanyaan;

  const AdminPertanyaanFormDialog({
    super.key,
    required this.kategoriList,
    this.pertanyaan,
  });

  @override
  State<AdminPertanyaanFormDialog> createState() =>
      _AdminPertanyaanFormDialogState();
}

class _AdminPertanyaanFormDialogState
    extends State<AdminPertanyaanFormDialog> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController pertanyaanController;
  late final TextEditingController bobotController;

  int? kategoriTerpilih;

  bool get modeEdit => widget.pertanyaan != null;

  @override
  void initState() {
    super.initState();

    pertanyaanController = TextEditingController(
      text: widget.pertanyaan?['pertanyaan']?.toString() ?? '',
    );

    bobotController = TextEditingController(
      text: widget.pertanyaan?['bobot']?.toString() ?? '1',
    );

    kategoriTerpilih = int.tryParse(
      widget.pertanyaan?['kategori_id']?.toString() ?? '',
    );

    if (!widget.kategoriList.any(
      (item) =>
          int.tryParse(item['id'].toString()) ==
          kategoriTerpilih,
    )) {
      kategoriTerpilih = null;
    }
  }

  @override
  void dispose() {
    pertanyaanController.dispose();
    bobotController.dispose();
    super.dispose();
  }

  void simpan() {
    if (!formKey.currentState!.validate()) return;

    if (kategoriTerpilih == null) return;

    final hasil = <String, dynamic>{
      'pertanyaan': pertanyaanController.text.trim(),
      'kategori_id': kategoriTerpilih!,
      'bobot': double.parse(bobotController.text.trim()),
    };

    Navigator.of(context).pop(hasil);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        modeEdit ? 'Edit Pertanyaan' : 'Tambah Pertanyaan',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: pertanyaanController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Pertanyaan',
                  hintText: 'Masukkan pertanyaan kuesioner',
                  prefixIcon: const Icon(Icons.quiz_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Pertanyaan wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              DropdownButtonFormField<int>(
                initialValue: kategoriTerpilih,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: const Icon(
                    Icons.category_outlined,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: widget.kategoriList.map((kategori) {
                  final id = int.parse(
                    kategori['id'].toString(),
                  );

                  return DropdownMenuItem<int>(
                    value: id,
                    child: Text(
                      kategori['nama'].toString(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    kategoriTerpilih = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Kategori wajib dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: bobotController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Bobot',
                  hintText: 'Contoh: 1',
                  prefixIcon: const Icon(
                    Icons.scale_outlined,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  final bobot = double.tryParse(
                    value?.trim() ?? '',
                  );

                  if (bobot == null || bobot <= 0) {
                    return 'Bobot harus lebih dari 0';
                  }

                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: simpan,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1976D2),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            modeEdit ? 'Simpan Perubahan' : 'Simpan',
          ),
        ),
      ],
    );
  }
}
