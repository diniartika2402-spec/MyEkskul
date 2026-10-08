import 'package:flutter/material.dart';

class AdminEkskulPage extends StatefulWidget {
  const AdminEkskulPage({super.key});

  @override
  State<AdminEkskulPage> createState() => _AdminEkskulPageState();
}

class _AdminEkskulPageState extends State<AdminEkskulPage> {
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

  void tambahEkskul() {
    final namaController = TextEditingController();
    final kategoriController = TextEditingController();
    final deskripsiController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Ekstrakurikuler'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Ekskul',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: kategoriController,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: deskripsiController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (namaController.text.trim().isEmpty) {
                  return;
                }

                setState(() {
                  ekskulList.add({
                    'nama': namaController.text.trim(),
                    'kategori': kategoriController.text.trim(),
                    'deskripsi': deskripsiController.text.trim(),
                  });
                });

                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void hapusEkskul(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Ekskul'),
          content: Text(
            'Apakah kamu yakin ingin menghapus ${ekskulList[index]['nama']}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  ekskulList.removeAt(index);
                });

                Navigator.pop(context);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Ekstrakurikuler'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: tambahEkskul,
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: ekskulList.length,
        itemBuilder: (context, index) {
          final ekskul = ekskulList[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.groups_outlined,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ekskul['nama'] ?? '',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ekskul['kategori'] ?? '',
                          style: const TextStyle(
                            color: Color(0xFF1976D2),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ekskul['deskripsi'] ?? '',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                // Fitur edit akan dibuat setelah database.
                              },
                              icon: const Icon(
                                Icons.edit_outlined,
                                color: Color(0xFF1976D2),
                              ),
                            ),
                            IconButton(
                              onPressed: () => hapusEkskul(index),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                            ),
                          ],
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
    );
  }
}