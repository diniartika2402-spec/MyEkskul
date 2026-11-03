
import 'package:flutter/material.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  static const Color primary = Color(0xFF0F766E);
  static const Color secondary = Color(0xFF14A098);
  static const Color background = Color(0xFFF5F7FA);
  static const Color textDark = Color(0xFF172033);
  static const Color muted = Color(0xFF64748B);
  static const Color border = Color(0xFFE7EBF1);
  static const Color softTeal = Color(0xFFE0F2F1);

  final TextEditingController searchController =
      TextEditingController();

  final List<Map<String, String>> users = [
    {
      'nama': 'Dini Artika',
      'email': 'dini@gmail.com',
      'role': 'Siswa',
    },
    {
      'nama': 'Andi Saputra',
      'email': 'andi@gmail.com',
      'role': 'Siswa',
    },
    {
      'nama': 'Siti Rahma',
      'email': 'siti@gmail.com',
      'role': 'Siswa',
    },
    {
      'nama': 'Admin MyEkskul',
      'email': 'admin@myekskul.com',
      'role': 'Admin',
    },
  ];

  String kataKunci = '';
  String filterRole = 'Semua';

  // Filter pengguna berdasarkan pencarian dan role.
  List<Map<String, String>> get usersTerfilter {
    return users.where((user) {
      final nama = (user['nama'] ?? '').toLowerCase();
      final email = (user['email'] ?? '').toLowerCase();
      final role = user['role'] ?? '';

      final cocokPencarian =
          nama.contains(kataKunci) ||
          email.contains(kataKunci);

      final cocokRole =
          filterRole == 'Semua' || filterRole == role;

      return cocokPencarian && cocokRole;
    }).toList();
  }

  int get jumlahSiswa =>
      users.where((user) => user['role'] == 'Siswa').length;

  int get jumlahAdmin =>
      users.where((user) => user['role'] == 'Admin').length;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Dialog konfirmasi hapus pengguna.
  void hapusUser(Map<String, String> user) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Hapus Pengguna',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          content: Text(
            'Apakah kamu yakin ingin menghapus ${user['nama']}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Batal',
                style: TextStyle(color: muted),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  users.remove(user);
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pengguna berhasil dihapus'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // Kartu statistik.
  Widget buildStatCard(
    String title,
    int value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 19,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '$value',
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                color: muted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Label role pengguna.
  Widget buildRoleBadge(String role) {
    final bool isAdmin = role == 'Admin';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: isAdmin
            ? const Color(0xFFFFF3E0)
            : softTeal,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        role,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isAdmin
              ? Colors.orange.shade800
              : primary,
        ),
      ),
    );
  }

  // Tabel pengguna tanpa scroll horizontal.
  Widget buildTable() {
    final data = usersTerfilter;

    if (data.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(13),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.person_search_outlined,
              size: 42,
              color: muted,
            ),
            SizedBox(height: 10),
            Text(
              'Pengguna tidak ditemukan',
              style: TextStyle(
                color: textDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Coba gunakan kata kunci atau filter lain.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: muted,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return DataTable(
              columnSpacing: 4,
              horizontalMargin: 8,
              dataRowMinHeight: 65,
              dataRowMaxHeight: 75,
              headingRowHeight: 45,
              headingRowColor:
                  WidgetStateProperty.all(softTeal),
              headingTextStyle: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
              dataTextStyle: const TextStyle(
                fontSize: 11,
                color: textDark,
              ),
              columns: const [
                DataColumn(label: Text('No')),
                DataColumn(label: Text('Pengguna')),
                DataColumn(label: Text('Role')),
                DataColumn(label: Text('Aksi')),
              ],
              rows: List.generate(data.length, (index) {
                final user = data[index];

                return DataRow(
                  cells: [
                    DataCell(
                      Text('${index + 1}'),
                    ),
                    DataCell(
                      SizedBox(
                        width: 125,
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              user['nama'] ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user['email'] ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 9,
                                color: muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DataCell(
                      buildRoleBadge(user['role'] ?? ''),
                    ),
                    DataCell(
                      IconButton(
                        tooltip: 'Hapus pengguna',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 30,
                          minHeight: 35,
                        ),
                        onPressed: () => hapusUser(user),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                          size: 19,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Kelola Pengguna',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
            color: textDark,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const Text(
              'Manajemen Pengguna',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Lihat dan kelola data pengguna MyEkskul.',
              style: TextStyle(
                fontSize: 13,
                color: muted,
              ),
            ),

            const SizedBox(height: 20),

            // Statistik pengguna.
            Row(
              children: [
                buildStatCard(
                  'Total',
                  users.length,
                  Icons.people_outline,
                  primary,
                ),
                const SizedBox(width: 8),
                buildStatCard(
                  'Siswa',
                  jumlahSiswa,
                  Icons.school_outlined,
                  Colors.blue,
                ),
                const SizedBox(width: 8),
                buildStatCard(
                  'Admin',
                  jumlahAdmin,
                  Icons.admin_panel_settings_outlined,
                  Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Daftar Pengguna',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 12),

            // Pencarian.
            TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  kataKunci = value.toLowerCase().trim();
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari nama atau email...',
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: muted,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: muted,
                ),
                suffixIcon: kataKunci.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            kataKunci = '';
                          });
                        },
                        icon: const Icon(Icons.close),
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Filter role.
            Wrap(
              spacing: 8,
              children: ['Semua', 'Siswa', 'Admin'].map((role) {
                final selected = filterRole == role;

                return ChoiceChip(
                  label: Text(role),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      filterRole = role;
                    });
                  },
                  selectedColor: primary,
                  backgroundColor: Colors.white,
                  showCheckmark: false,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : muted,
                  ),
                  side: BorderSide(
                    color: selected ? primary : border,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 15),

            Text(
              '${usersTerfilter.length} pengguna ditampilkan',
              style: const TextStyle(
                fontSize: 12,
                color: muted,
              ),
            ),

            const SizedBox(height: 10),

            // Tabel utama.
            buildTable(),
          ],
        ),
      ),
    );
  }
}
