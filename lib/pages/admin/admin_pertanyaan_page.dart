import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminPertanyaanPage extends StatefulWidget {
  const AdminPertanyaanPage({super.key});

  @override
  State<AdminPertanyaanPage> createState() => _AdminPertanyaanPageState();
}

class _AdminPertanyaanPageState extends State<AdminPertanyaanPage> {
  final String pertanyaanUrl =
      'http://10.0.2.2/myekskul_api/pertanyaan/get.php';

  final String kategoriUrl =
      'http://10.0.2.2/myekskul_api/kategori/get.php';

  final String tambahUrl =
      'http://10.0.2.2/myekskul_api/pertanyaan/tambah.php';

  List<dynamic> pertanyaanList = [];
  List<dynamic> kategoriList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    ambilData();
  }

  Future<void> ambilData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final hasilPertanyaan = await http.get(
        Uri.parse(pertanyaanUrl),
      );

      final hasilKategori = await http.get(
        Uri.parse(kategoriUrl),
      );

      if (hasilPertanyaan.statusCode == 200 &&
          hasilKategori.statusCode == 200) {
        final dataPertanyaan =
            jsonDecode(hasilPertanyaan.body);

        final dataKategori =
            jsonDecode(hasilKategori.body);

        if (dataPertanyaan['success'] == true &&
            dataKategori['success'] == true) {
          setState(() {
            pertanyaanList =
                dataPertanyaan['data'] ?? [];

            kategoriList =
                dataKategori['data'] ?? [];

            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });

          tampilkanPesan(
            'Gagal mengambil data',
          );
        }
      } else {
        setState(() {
          isLoading = false;
        });

        tampilkanPesan(
          'Gagal terhubung ke server',
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      tampilkanPesan(
        'Terjadi kesalahan: $e',
      );
    }
  }

  void tampilkanPesan(String pesan) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
      ),
    );
  }

  void bukaFormTambah() {
    final pertanyaanController = TextEditingController();
    final bobotController = TextEditingController(
      text: '1',
    );

    int? kategoriTerpilih;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Tambah Pertanyaan',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: pertanyaanController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Pertanyaan',
                        hintText:
                            'Masukkan pertanyaan kuesioner',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    DropdownButtonFormField<int>(
                      value: kategoriTerpilih,
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(),
                      ),
                      items: kategoriList.map((kategori) {
                        return DropdownMenuItem<int>(
                          value: int.parse(
                            kategori['id'].toString(),
                          ),
                          child: Text(
                            kategori['nama'].toString(),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          kategoriTerpilih = value;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: bobotController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Bobot',
                        hintText: 'Contoh: 1',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Batal'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    final teks =
                        pertanyaanController.text.trim();

                    if (teks.isEmpty) {
                      tampilkanPesan(
                        'Pertanyaan wajib diisi',
                      );
                      return;
                    }

                    if (kategoriTerpilih == null) {
                      tampilkanPesan(
                        'Kategori wajib dipilih',
                      );
                      return;
                    }

                    final bobot = double.tryParse(
                      bobotController.text.trim(),
                    );

                    if (bobot == null || bobot <= 0) {
                      tampilkanPesan(
                        'Bobot harus berupa angka lebih dari 0',
                      );
                      return;
                    }

                    Navigator.pop(dialogContext);

                    await tambahPertanyaan(
                      teks,
                      kategoriTerpilih!,
                      bobot,
                    );
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> tambahPertanyaan(
    String pertanyaan,
    int kategoriId,
    double bobot,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(tambahUrl),
        body: {
          'pertanyaan': pertanyaan,
          'kategori_id': kategoriId.toString(),
          'bobot': bobot.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          tampilkanPesan(
            'Pertanyaan berhasil ditambahkan',
          );

          await ambilData();
        } else {
          tampilkanPesan(
            data['message']?.toString() ??
                'Gagal menambahkan pertanyaan',
          );
        }
      } else {
        tampilkanPesan(
          'Gagal terhubung ke server',
        );
      }
    } catch (e) {
      tampilkanPesan(
        'Terjadi kesalahan: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kelola Pertanyaan',
        ),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: bukaFormTambah,
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),

      body: RefreshIndicator(
        onRefresh: ambilData,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : pertanyaanList.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 150),
                      Center(
                        child: Text(
                          'Belum ada pertanyaan',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: pertanyaanList.length,
                    itemBuilder: (context, index) {
                      final pertanyaan =
                          pertanyaanList[index];

                      final String teks =
                          pertanyaan['pertanyaan']
                                  ?.toString() ??
                              '';

                      final String kategori =
                          pertanyaan['kategori']
                                  ?.toString() ??
                              '-';

                      final String bobot =
                          pertanyaan['bobot']
                                  ?.toString() ??
                              '-';

                      return Card(
                        margin:
                            const EdgeInsets.only(
                          bottom: 15,
                        ),
                        elevation: 2,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration:
                                    BoxDecoration(
                                  color: const Color(
                                    0xFFE3F2FD,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style:
                                        const TextStyle(
                                      color: Color(
                                        0xFF1976D2,
                                      ),
                                      fontWeight:
                                          FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                width: 15,
                              ),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Text(
                                      teks,
                                      style:
                                          const TextStyle(
                                        fontSize: 15,
                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 8,
                                    ),

                                    Text(
                                      'Kategori: $kategori',
                                      style:
                                          const TextStyle(
                                        color:
                                            Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 3,
                                    ),

                                    Text(
                                      'Bobot: $bobot',
                                      style:
                                          const TextStyle(
                                        color:
                                            Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}