import 'package:flutter/material.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
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

  void hapusUser(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Pengguna'),
          content: Text(
            'Apakah kamu yakin ingin menghapus ${users[index]['nama']}?',
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
                  users.removeAt(index);
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
        title: const Text('Kelola Pengguna'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];

          final bool isAdmin = user['role'] == 'Admin';

          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 27,
                    backgroundColor: isAdmin
                        ? const Color(0xFFFFE0B2)
                        : const Color(0xFFE3F2FD),
                    child: Icon(
                      isAdmin
                          ? Icons.admin_panel_settings_outlined
                          : Icons.person_outline,
                      color: isAdmin
                          ? Colors.orange
                          : const Color(0xFF1976D2),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['nama'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          user['email'] ?? '',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: isAdmin
                                ? const Color(0xFFFFF3E0)
                                : const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            user['role'] ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isAdmin
                                  ? Colors.orange
                                  : const Color(0xFF1976D2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      hapusUser(index);
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
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