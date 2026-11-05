
import 'package:flutter/material.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  static const Color primary = Color(0xFF0F766E);
  static const Color secondary = Color(0xFF14A098);
  static const Color background = Color(0xFFF5F7FA);
  static const Color textColor = Color(0xFF172033);
  static const Color muted = Color(0xFF64748B);
  static const Color softTeal = Color(0xFFE0F2F1);
  static const Color border = Color(0xFFE7EBF1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: textColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 54,
        title: const Text(
          'Profil Admin',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double height = constraints.maxHeight;
            final bool compact = height < 620;

            return Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                compact ? 8 : 14,
                16,
                compact ? 8 : 14,
              ),
              child: Column(
                children: [
                  // HEADER PROFIL
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: compact ? 10 : 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: border),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: compact ? 29 : 35,
                          backgroundColor: softTeal,
                          child: Icon(
                            Icons.admin_panel_settings_rounded,
                            size: compact ? 34 : 40,
                            color: primary,
                          ),
                        ),
                        SizedBox(height: compact ? 6 : 9),
                        const Text(
                          'Admin MyEkskul',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: softTeal,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Administrator',
                            style: TextStyle(
                              color: primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: compact ? 12 : 18),

                  // JUDUL INFORMASI
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Informasi Akun',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  SizedBox(height: compact ? 8 : 12),

                  // INFORMASI AKUN
                  _infoCard(
                    icon: Icons.person_outline_rounded,
                    title: 'Nama Lengkap',
                    value: 'Admin MyEkskul',
                    compact: compact,
                  ),

                  _infoCard(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    value: 'admin@myekskul.com',
                    compact: compact,
                  ),

                  _infoCard(
                    icon: Icons.verified_user_outlined,
                    title: 'Hak Akses',
                    value: 'Administrator',
                    compact: compact,
                  ),

                  _infoCard(
                    icon: Icons.school_outlined,
                    title: 'Nama Sistem',
                    value: 'MyEkskul',
                    compact: compact,
                  ),

                  const Spacer(),

                  // LOGOUT
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton.icon(
                      onPressed: () => _confirmLogout(context),
                      icon: const Icon(
                        Icons.logout_rounded,
                        size: 19,
                      ),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.red.shade200,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    required bool compact,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: compact ? 6 : 9),
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: compact ? 8 : 11,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: compact ? 36 : 40,
            height: compact ? 36 : 40,
            decoration: BoxDecoration(
              color: softTeal,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle_rounded,
            color: primary,
            size: 17,
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Konfirmasi Logout',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          content: const Text(
            'Apakah kamu yakin ingin keluar dari akun admin?',
            style: TextStyle(
              color: muted,
              fontSize: 13,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Batal',
                style: TextStyle(color: muted),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logout berhasil'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
