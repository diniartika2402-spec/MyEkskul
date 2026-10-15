
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final int userId;
  final String nama;
  final String email;

  const ProfilePage({
    super.key,
    required this.userId,
    required this.nama,
    required this.email,
  });

  static const Color primary = Color(0xFF0F766E);
  static const Color dark = Color(0xFF115E59);
  static const Color background = Color(0xFFF4F7F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        toolbarHeight: 52,
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            final compact = height < 620;

            final avatarSize = compact ? 48.0 : 58.0;
            final headerPadding = compact ? 10.0 : 14.0;
            final sectionGap = compact ? 12.0 : 18.0;
            final cardGap = compact ? 6.0 : 8.0;

            return Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                compact ? 8 : 12,
                16,
                compact ? 8 : 12,
              ),
              child: Column(
                children: [
                  // HEADER PROFIL
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: headerPadding,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [primary, dark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: avatarSize,
                          height: avatarSize,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.17),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white70,
                              width: 1.8,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              nama.trim().isEmpty
                                  ? '?'
                                  : nama.trim()[0].toUpperCase(),
                              style: TextStyle(
                                fontSize: compact ? 23 : 27,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: compact ? 6 : 9),
                        Text(
                          nama.trim().isEmpty
                              ? 'Pengguna MyEkskul'
                              : nama.trim(),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: compact ? 18 : 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          email.trim().isEmpty
                              ? 'Email belum tersedia'
                              : email.trim(),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: compact ? 11 : 12,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: compact ? 7 : 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_user_outlined,
                                color: Colors.white,
                                size: 14,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Profil Pengguna',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: sectionGap),

                  // JUDUL INFORMASI
                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCCFBF1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.manage_accounts_outlined,
                          color: primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 9),
                      const Expanded(
                        child: Text(
                          'Informasi Akun',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF172B3A),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: compact ? 8 : 10),

                  // KARTU INFORMASI
                  _InfoCard(
                    icon: Icons.badge_outlined,
                    title: 'ID Pengguna',
                    value: userId.toString(),
                    compact: compact,
                  ),
                  SizedBox(height: cardGap),
                  _InfoCard(
                    icon: Icons.person_outline_rounded,
                    title: 'Nama Lengkap',
                    value: nama.trim().isEmpty
                        ? 'Nama belum tersedia'
                        : nama.trim(),
                    compact: compact,
                  ),
                  SizedBox(height: cardGap),
                  _InfoCard(
                    icon: Icons.email_outlined,
                    title: 'Alamat Email',
                    value: email.trim().isEmpty
                        ? 'Email belum tersedia'
                        : email.trim(),
                    compact: compact,
                  ),

                  const Spacer(),

                  // CATATAN BAWAH
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(compact ? 9 : 11),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCCFBF1),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: const Color(0xFF99F6E4),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          color: dark,
                          size: 19,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Untuk memperbarui data akun, hubungi '
                            'pihak pengelola aplikasi.',
                            style: TextStyle(
                              color: dark,
                              fontSize: 11,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
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
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool compact;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = compact ? 34.0 : 38.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 11,
        vertical: compact ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE5ECEE),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: const Color(0xFFCCFBF1),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF0F766E),
              size: compact ? 19 : 21,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: compact ? 11 : 12,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: compact ? 13 : 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
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
