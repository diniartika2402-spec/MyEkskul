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
  final String apiUrl =
      'http://10.0.2.2/myekskul_api/ekskul/get.php';

  List<dynamic> ekskulList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    ambilEkskul();
  }

  Future<void> ambilEkskul() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          setState(() {
            ekskulList = data['data'] ?? [];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });

          tampilkanPesan(
            'Gagal mengambil data ekstrakurikuler',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ekstrakurikuler',
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: ambilEkskul,
              child: ekskulList.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 150),
                        Center(
                          child: Text(
                            'Belum ada ekstrakurikuler',
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
                      itemCount: ekskulList.length,
                      itemBuilder: (context, index) {
                        final ekskul =
                            ekskulList[index];

                        final String nama =
                            ekskul['nama']?.toString() ?? '';

                        final String deskripsi =
                            ekskul['deskripsi']?.toString() ?? '';

                        final String jadwal =
                            ekskul['jadwal']?.toString() ?? '';

                        final String lokasi =
                            ekskul['lokasi']?.toString() ?? '';

                        final String pembina =
                            ekskul['pembina']?.toString() ?? '';

                        final List<dynamic> dokumentasi =
                            ekskul['dokumentasi'] ?? [];

                        return Card(
                          margin: const EdgeInsets.only(
                            bottom: 15,
                          ),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.all(15),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFFE3F2FD),
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.groups_outlined,
                                color:
                                    Color(0xFF1976D2),
                                size: 28,
                              ),
                            ),
                            title: Text(
                              nama,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Padding(
                              padding:
                                  const EdgeInsets.only(
                                top: 6,
                              ),
                              child: Text(
                                deskripsi.isEmpty
                                    ? 'Belum ada deskripsi'
                                    : deskripsi,
                                maxLines: 2,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DetailEkstrakurikulerPage(
                                    nama: nama,
                                    deskripsi: deskripsi,
                                    jadwal: jadwal,
                                    lokasi: lokasi,
                                    pembina: pembina,
                                    dokumentasi:
                                        dokumentasi,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}