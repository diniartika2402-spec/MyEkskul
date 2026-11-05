
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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

  // Sesuaikan alamat jika menggunakan perangkat fisik.
  static const String baseUrl =
      'http://10.0.2.2/myekskul_api/ekskul/';

  static const String uploadUrl =
      'http://10.0.2.2/myekskul_api/ekskul/dokumentasi/upload_dokumentasi.php';

  final TextEditingController searchController =
      TextEditingController();

  final ImagePicker imagePicker = ImagePicker();

  List<Map<String, dynamic>> ekskulList = [];

  bool isLoading = true;
  bool isSaving = false;
  String searchQuery = '';

  List<Map<String, dynamic>> get filteredEkskul {
    final query = searchQuery.toLowerCase().trim();

    if (query.isEmpty) return ekskulList;

    return ekskulList.where((item) {
      return (item['nama'] ?? '')
              .toString()
              .toLowerCase()
              .contains(query) ||
          (item['pembina'] ?? '')
              .toString()
              .toLowerCase()
              .contains(query);
    }).toList();
  }

  int get totalAktif => ekskulList
      .where((e) => e['status'] == 'aktif')
      .length;

  int get totalNonaktif => ekskulList
      .where((e) => e['status'] == 'nonaktif')
      .length;

  @override
  void initState() {
    super.initState();
    ambilData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void tampilkanPesan(String pesan, {bool error = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        backgroundColor: error ? Colors.red : primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ==============================
  // AMBIL DATA EKSKUL
  // ==============================

  Future<void> ambilData() async {
    if (mounted) {
      setState(() => isLoading = true);
    }

    try {
      final response = await http
          .get(Uri.parse('${baseUrl}admin_get.php'))
          .timeout(const Duration(seconds: 20));

      if (response.statusCode != 200) {
        throw Exception('Server tidak merespons');
      }

      final result = jsonDecode(response.body);

      if (result['success'] != true) {
        throw Exception(result['message'] ?? 'Gagal mengambil data');
      }

      final List<dynamic> data = result['data'] ?? [];

      final List<Map<String, dynamic>> hasil = data
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      // Ambil dokumentasi setiap ekskul.
      for (final ekskul in hasil) {
        try {
          final id = ekskul['id'].toString();

          final fotoResponse = await http.get(
            Uri.parse(
              '${baseUrl}get_dokumentasi.php?ekskul_id=$id',
            ),
          ).timeout(const Duration(seconds: 15));

          if (fotoResponse.statusCode == 200) {
            final fotoData = jsonDecode(fotoResponse.body);

            ekskul['dokumentasi'] =
                fotoData['success'] == true
                    ? fotoData['data'] ?? []
                    : [];
          } else {
            ekskul['dokumentasi'] = [];
          }
        } catch (_) {
          ekskul['dokumentasi'] = [];
        }
      }

      if (!mounted) return;

      setState(() {
        ekskulList = hasil;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);
      tampilkanPesan(
        'Gagal mengambil data: $e',
        error: true,
      );
    }
  }

  // ==============================
  // FORM TAMBAH DAN EDIT
  // ==============================

  Future<void> bukaForm({
    Map<String, dynamic>? ekskul,
  }) async {
    final isEdit = ekskul != null;

    final namaController = TextEditingController(
      text: ekskul?['nama']?.toString() ?? '',
    );

    final deskripsiController = TextEditingController(
      text: ekskul?['deskripsi']?.toString() ?? '',
    );

    final jadwalController = TextEditingController(
      text: ekskul?['jadwal']?.toString() ?? '',
    );

    final lokasiController = TextEditingController(
      text: ekskul?['lokasi']?.toString() ?? '',
    );

    final pembinaController = TextEditingController(
      text: ekskul?['pembina']?.toString() ?? '',
    );

    String status = ekskul?['status']?.toString() ?? 'aktif';
    XFile? fotoTerpilih;

    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
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
                width: 430,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _formField(
                          namaController,
                          'Nama Ekstrakurikuler',
                          Icons.groups_rounded,
                          hint: 'Contoh: Basket',
                        ),
                        _gap,
                        _formField(
                          deskripsiController,
                          'Deskripsi',
                          Icons.description_outlined,
                          hint: 'Deskripsi kegiatan',
                          maxLines: 3,
                          required: false,
                        ),
                        _gap,
                        _formField(
                          jadwalController,
                          'Jadwal',
                          Icons.calendar_month_outlined,
                          hint: 'Contoh: Jumat, 15.00',
                          required: false,
                        ),
                        _gap,
                        _formField(
                          lokasiController,
                          'Lokasi',
                          Icons.location_on_outlined,
                          hint: 'Contoh: Lapangan sekolah',
                          required: false,
                        ),
                        _gap,
                        _formField(
                          pembinaController,
                          'Pembina',
                          Icons.person_outline_rounded,
                          hint: 'Nama pembina ekskul',
                          required: false,
                        ),
                        _gap,

                        // Status
                        DropdownButtonFormField<String>(
                          initialValue: status,
                          decoration: _inputDecoration(
                            'Status',
                            Icons.toggle_on_outlined,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'aktif',
                              child: Text('Aktif'),
                            ),
                            DropdownMenuItem(
                              value: 'nonaktif',
                              child: Text('Nonaktif'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setDialogState(() => status = value);
                            }
                          },
                        ),

                        _gap,

                        // Dokumentasi
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.photo_library_outlined,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Dokumentasi Kegiatan',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              if (fotoTerpilih != null)
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  child: Image.file(
                                    File(fotoTerpilih!.path),
                                    width: double.infinity,
                                    height: 140,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                              if (fotoTerpilih != null)
                                const SizedBox(height: 10),

                              OutlinedButton.icon(
                                onPressed: () async {
                                  final foto =
                                      await imagePicker.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 80,
                                  );

                                  if (foto != null) {
                                    setDialogState(() {
                                      fotoTerpilih = foto;
                                    });
                                  }
                                },
                                icon: const Icon(
                                  Icons.add_photo_alternate_outlined,
                                ),
                                label: const Text('Pilih Foto'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: primaryColor,
                                ),
                              ),

                              const Text(
                                'Format JPG, PNG, atau WEBP. '
                                'Maksimal 5 MB.',
                                style: TextStyle(
                                  color: mutedColor,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actionsPadding:
                  const EdgeInsets.fromLTRB(18, 0, 18, 16),
              actions: [
                TextButton(
                  onPressed: isSaving
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                ElevatedButton.icon(
                  onPressed: isSaving
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }

                          setDialogState(() => isSaving = true);

                          final berhasil = await simpanEkskul(
                            isEdit: isEdit,
                            id: ekskul?['id'],
                            nama: namaController.text.trim(),
                            deskripsi:
                                deskripsiController.text.trim(),
                            jadwal: jadwalController.text.trim(),
                            lokasi: lokasiController.text.trim(),
                            pembina: pembinaController.text.trim(),
                            status: status,
                            foto: fotoTerpilih,
                          );

                          if (!dialogContext.mounted) return;

                          if (berhasil) {
                            Navigator.pop(dialogContext);
                          } else {
                            setDialogState(() => isSaving = false);
                          }
                        },
                  icon: isSaving
                      ? const SizedBox(
                          width: 17,
                          height: 17,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_outlined, size: 19),
                  label: Text(isSaving ? 'Menyimpan...' : 'Simpan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    namaController.dispose();
    deskripsiController.dispose();
    jadwalController.dispose();
    lokasiController.dispose();
    pembinaController.dispose();
  }

  static const SizedBox _gap = SizedBox(height: 13);

  Widget _formField(
    TextEditingController controller,
    String label,
    IconData icon, {
    String? hint,
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
      decoration: _inputDecoration(
        label,
        icon,
        hint: hint,
        maxLines: maxLines,
      ),
    );
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon, {
    String? hint,
    int maxLines = 1,
  }) {
    return InputDecoration(
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
        borderSide: const BorderSide(
          color: primaryColor,
          width: 1.5,
        ),
      ),
    );
  }

  // ==============================
  // SIMPAN DATA
  // ==============================

  Future<bool> simpanEkskul({
    required bool isEdit,
    dynamic id,
    required String nama,
    required String deskripsi,
    required String jadwal,
    required String lokasi,
    required String pembina,
    required String status,
    XFile? foto,
  }) async {
    try {
      final url = isEdit
          ? '${baseUrl}update.php'
          : '${baseUrl}tambah.php';

      final body = <String, String>{
        'nama': nama,
        'deskripsi': deskripsi,
        'jadwal': jadwal,
        'lokasi': lokasi,
        'pembina': pembina,
      };

      if (isEdit) {
        body['id'] = id.toString();
        body['status'] = status;
      }

      final response = await http.post(
        Uri.parse(url),
        body: body,
      ).timeout(const Duration(seconds: 20));

      final result = jsonDecode(response.body);

      if (response.statusCode != 200 ||
          result['success'] != true) {
        throw Exception(
          result['message'] ?? 'Gagal menyimpan ekskul',
        );
      }

      // ID dibutuhkan untuk mengunggah dokumentasi.
      final ekskulId = isEdit
          ? id.toString()
          : result['id'].toString();

      if (foto != null) {
        await uploadDokumentasi(
          ekskulId,
          foto,
        );
      }

      if (!mounted) return true;

      tampilkanPesan(
        isEdit
            ? 'Ekskul berhasil diperbarui'
            : 'Ekskul berhasil ditambahkan',
      );

      await ambilData();

      return true;
    } catch (e) {
      tampilkanPesan(
        'Gagal menyimpan: $e',
        error: true,
      );
      return false;
    }
  }

  // ==============================
  // UPLOAD DOKUMENTASI
  // ==============================

  Future<void> uploadDokumentasi(
    String ekskulId,
    XFile foto,
  ) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(uploadUrl),
    );

    request.fields['ekskul_id'] = ekskulId;
    request.fields['keterangan'] = 'Dokumentasi kegiatan';

    request.files.add(
      await http.MultipartFile.fromPath(
        'gambar',
        foto.path,
      ),
    );

    final streamedResponse = await request.send()
        .timeout(const Duration(seconds: 60));

    final response = await http.Response.fromStream(
      streamedResponse,
    );

    final result = jsonDecode(response.body);

    if (response.statusCode != 200 ||
        result['success'] != true) {
      throw Exception(
        result['message'] ?? 'Gagal mengunggah foto',
      );
    }
  }

  // ==============================
  // HAPUS / NONAKTIFKAN
  // ==============================

  Future<void> nonaktifkanEkskul(
    Map<String, dynamic> ekskul,
  ) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nonaktifkan Ekskul?'),
        content: Text(
          'Apakah kamu yakin ingin menonaktifkan '
          '${ekskul['nama']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Nonaktifkan'),
          ),
        ],
      ),
    );

    if (konfirmasi != true) return;

    try {
      final response = await http.post(
        Uri.parse('${baseUrl}nonaktifkan.php'),
        body: {'id': ekskul['id'].toString()},
      );

      final result = jsonDecode(response.body);

      if (result['success'] != true) {
        throw Exception(result['message']);
      }

      tampilkanPesan('Ekskul berhasil dinonaktifkan');
      await ambilData();
    } catch (e) {
      tampilkanPesan(
        'Gagal menonaktifkan ekskul: $e',
        error: true,
      );
    }
  }

  // ==============================
  // AKTIFKAN KEMBALI
  // ==============================

  Future<void> aktifkanEkskul(
    Map<String, dynamic> ekskul,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}update.php'),
        body: {
          'id': ekskul['id'].toString(),
          'nama': ekskul['nama'].toString(),
          'deskripsi': ekskul['deskripsi']?.toString() ?? '',
          'jadwal': ekskul['jadwal']?.toString() ?? '',
          'lokasi': ekskul['lokasi']?.toString() ?? '',
          'pembina': ekskul['pembina']?.toString() ?? '',
          'status': 'aktif',
        },
      );

      final result = jsonDecode(response.body);

      if (result['success'] != true) {
        throw Exception(result['message']);
      }

      tampilkanPesan('Ekskul berhasil diaktifkan');
      await ambilData();
    } catch (e) {
      tampilkanPesan(
        'Gagal mengaktifkan ekskul: $e',
        error: true,
      );
    }
  }

  // ==============================
  // UI
  // ==============================

  @override
  Widget build(BuildContext context) {
    final data = filteredEkskul;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kelola Ekskul',
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Data ekstrakurikuler sekolah',
              style: TextStyle(
                color: mutedColor,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => bukaForm(),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah Ekskul',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 15),
            child: Row(
              children: [
                Expanded(
                  child: _summaryCard(
                    'Total Ekskul',
                    '${ekskulList.length}',
                    Icons.groups_rounded,
                    primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _summaryCard(
                    'Aktif',
                    '$totalAktif',
                    Icons.check_circle_outline,
                    const Color(0xFF16A34A),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _summaryCard(
                    'Nonaktif',
                    '$totalNonaktif',
                    Icons.pause_circle_outline,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() => searchQuery = value);
              },
              decoration: InputDecoration(
                hintText: 'Cari nama atau pembina ekskul...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(
                    color: Color(0xFFE2E8F0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(
                    color: Color(0xFFE2E8F0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: ambilData,
                    child: data.isEmpty
                        ? ListView(
                            children: const [
                              SizedBox(height: 100),
                              Icon(
                                Icons.groups_outlined,
                                size: 55,
                                color: Color(0xFF94A3B8),
                              ),
                              SizedBox(height: 12),
                              Center(
                                child: Text(
                                  'Belum ada data ekskul',
                                  style: TextStyle(
                                    color: mutedColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(
                              16, 3, 16, 95,
                            ),
                            itemCount: data.length,
                            separatorBuilder: (_, index) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final ekskul = data[index];
                              final aktif =
                                  ekskul['status'] == 'aktif';

                              final foto =
                                  ekskul['dokumentasi'] as List? ?? [];

                              return Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFFE7EBF1),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 43,
                                          height: 43,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE0F2F1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: const Icon(
                                            Icons.groups_rounded,
                                            color: primaryColor,
                                          ),
                                        ),
                                        const SizedBox(width: 11),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ekskul['nama'] ?? '',
                                                style: const TextStyle(
                                                  color: textColor,
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.w800,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              _statusBadge(aktif),
                                            ],
                                          ),
                                        ),
                                        PopupMenuButton<String>(
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              bukaForm(ekskul: ekskul);
                                            } else if (value == 'nonaktif') {
                                              nonaktifkanEkskul(ekskul);
                                            } else if (value == 'aktif') {
                                              aktifkanEkskul(ekskul);
                                            }
                                          },
                                          itemBuilder: (_) => [
                                            const PopupMenuItem(
                                              value: 'edit',
                                              child: Text('Edit Ekskul'),
                                            ),
                                            if (aktif)
                                              const PopupMenuItem(
                                                value: 'nonaktif',
                                                child: Text(
                                                  'Nonaktifkan',
                                                ),
                                              )
                                            else
                                              const PopupMenuItem(
                                                value: 'aktif',
                                                child: Text('Aktifkan'),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 12),

                                    if ((ekskul['deskripsi'] ?? '')
                                        .toString().isNotEmpty)
                                      Text(
                                        ekskul['deskripsi'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: mutedColor,
                                          height: 1.4,
                                        ),
                                      ),

                                    const SizedBox(height: 10),

                                    _infoRow(
                                      Icons.calendar_month_outlined,
                                      ekskul['jadwal'] ?? '-',
                                    ),
                                    _infoRow(
                                      Icons.location_on_outlined,
                                      ekskul['lokasi'] ?? '-',
                                    ),
                                    _infoRow(
                                      Icons.person_outline,
                                      ekskul['pembina'] ?? '-',
                                    ),

                                    if (foto.isNotEmpty) ...[
                                      const SizedBox(height: 12),
                                      const Text(
                                        'Dokumentasi',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        height: 85,
                                        child: ListView.separated(
                                          scrollDirection:
                                              Axis.horizontal,
                                          itemCount: foto.length,
                                          separatorBuilder: (_, index) =>
                                              const SizedBox(width: 8),
                                          itemBuilder: (_, fotoIndex) {
                                            final url =
                                                foto[fotoIndex]['url']
                                                    ?.toString() ?? '';

                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                              child: url.isEmpty
                                                  ? const SizedBox()
                                                  : Image.network(
                                                      url,
                                                      width: 105,
                                                      height: 85,
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (_, error, stack) =>
                                                              Container(
                                                        width: 105,
                                                        color: backgroundColor,
                                                        child: const Icon(
                                                          Icons.broken_image,
                                                        ),
                                                      ),
                                                    ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],

                                    const SizedBox(height: 8),

                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton.icon(
                                        onPressed: () =>
                                            bukaForm(ekskul: ekskul),
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          size: 17,
                                        ),
                                        label: const Text('Edit Detail'),
                                        style: TextButton.styleFrom(
                                          foregroundColor: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(bool aktif) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: aktif
            ? const Color(0xFFDCFCE7)
            : const Color(0xFFFFEDD5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        aktif ? 'AKTIF' : 'NONAKTIF',
        style: TextStyle(
          color: aktif
              ? const Color(0xFF15803D)
              : const Color(0xFFC2410C),
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: mutedColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(
                fontSize: 11,
                color: mutedColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: mutedColor,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}
