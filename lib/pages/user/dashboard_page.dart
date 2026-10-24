import 'package:flutter/material.dart';

import 'kuesioner_page.dart';
import 'hasil_page.dart';
import 'ekstrakurikuler_page.dart';
import 'profile_page.dart';
import 'tentang_page.dart';
import '../auth/login_page.dart';

class DashboardPage extends StatelessWidget {
  final int userId;
  final String nama;
  final String email;

  const DashboardPage({
    super.key,
    required this.userId,
    required this.nama,
    required this.email,
  });

  // =========================================================
  // NAVIGASI
  // =========================================================

  void _openKuesioner(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KuesionerPage(
          userId: userId,
        ),
      ),
    );
  }

  void _openHasil(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HasilPage(
          userId: userId,
        ),
      ),
    );
  }

  void _openEkskul(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EkstrakurikulerPage(),
      ),
    );
  }

  void _openProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfilePage(
          userId: userId,
          nama: nama,
          email: email,
        ),
      ),
    );
  }

  void _openTentang(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TentangPage(),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
  final konfirmasi = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text('Konfirmasi Logout'),
      content: const Text(
        'Apakah kamu yakin ingin keluar dari akun MyEkskul?',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext, false);
          },
          child: const Text('Batal'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(dialogContext, true);
          },
          icon: const Icon(Icons.logout_rounded, size: 18),
          label: const Text('Ya, Logout'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFDC2626),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    ),
  );

  if (konfirmasi != true || !context.mounted) return;

  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (_) => const LoginPage(),
    ),
    (route) => false,
  );
}

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              padding: const EdgeInsets.fromLTRB(
                18,
                16,
                18,
                20,
              ),

              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 36,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // =====================================================
                    // HEADER
                    // =====================================================

                    Row(
                      children: [

                        // LOGO
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F766E),
                            borderRadius: BorderRadius.circular(14),
                          ),

                          child: const Icon(
                            Icons.school_rounded,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // NAMA APLIKASI
                        const Expanded(
                          child: Text(
                            'MyEkskul',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF172033),
                            ),
                          ),
                        ),

                    

PopupMenuButton<String>(
  tooltip: 'Menu akun',
  icon: const Icon(
    Icons.person_outline_rounded,
    color: Color(0xFF334155),
  ),
  style: IconButton.styleFrom(
    backgroundColor: Colors.white,
    side: const BorderSide(
      color: Color(0xFFE5EAF1),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
    fixedSize: const Size(46, 46),
  ),
  onSelected: (value) {
    if (value == 'profile') {
      _openProfile(context);
    } else if (value == 'logout') {
      _logout(context);
    }
  },
  itemBuilder: (context) => [
    const PopupMenuItem<String>(
      value: 'profile',
      child: ListTile(
        leading: Icon(Icons.person_outline_rounded),
        title: Text('Profil Saya'),
        contentPadding: EdgeInsets.zero,
      ),
    ),
    const PopupMenuItem<String>(
      value: 'logout',
      child: ListTile(
        leading: Icon(
          Icons.logout_rounded,
          color: Color(0xFFDC2626),
        ),
        title: Text(
          'Logout',
          style: TextStyle(color: Color(0xFFDC2626)),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    ),
  ],
), // tutup PopupMenuButton
      ],
    ), // tutup Row

const SizedBox(height: 22),




                    // =====================================================
                    // SAPAAN
                    // =====================================================

                    Text(
                      'Halo, ${nama.split(' ').first} 👋',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF172033),
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'Temukan kegiatan yang sesuai dengan\nminat dan bakatmu.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        color: Color(0xFF8993A4),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // =====================================================
                    // CARD REKOMENDASI
                    // =====================================================

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,

                          colors: [
                            Color(0xFF0F8B83),
                            Color(0xFF0C756E),
                          ],
                        ),

                        borderRadius: BorderRadius.circular(24),

                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F766E)
                                .withOpacity(0.18),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),

                      child: Row(
                        children: [

                          // TEKS
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: [

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),

                                  decoration: BoxDecoration(
                                    color: Colors.white
                                        .withOpacity(0.16),
                                    borderRadius:
                                        BorderRadius.circular(20),
                                  ),

                                  child: const Text(
                                    'REKOMENDASI EKSKUL',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                const Text(
                                  'Cari Ekskul\nYang Cocok\nUntukmu',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 21,
                                    height: 1.08,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                const Text(
                                  'Isi kuesioner singkat untuk mengetahui rekomendasi ekskul yang sesuai.',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,

                                  style: TextStyle(
                                    color: Color(0xFFD6F3F0),
                                    fontSize: 11,
                                    height: 1.35,
                                  ),
                                ),

                                const SizedBox(height: 14),

                                // TOMBOL
                                SizedBox(
                                  height: 40,

                                  child: ElevatedButton(
                                    onPressed: () {
                                      _openKuesioner(context);
                                    },

                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor:
                                          const Color(0xFF0F766E),

                                      elevation: 0,

                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),

                                      shape:
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                    ),

                                    child: const Row(
                                      mainAxisSize:
                                          MainAxisSize.min,

                                      children: [

                                        Text(
                                          'Mulai Kuesioner',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight:
                                                FontWeight.w800,
                                          ),
                                        ),

                                        SizedBox(width: 7),

                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 17,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          // ICON KANAN
                          Container(
                            width: 64,
                            height: 64,

                            decoration: BoxDecoration(
                              color: Colors.white
                                  .withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.auto_awesome_rounded,
                              color: Colors.white,
                              size: 31,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // =====================================================
                    // JUDUL MENU
                    // =====================================================

                    const Text(
                      'Menu Utama',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF172033),
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Akses fitur MyEkskul dengan mudah',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9AA3B2),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // =====================================================
                    // MENU GRID
                    // =====================================================

                    Row(
                      children: [

                        Expanded(
                          child: _MenuCard(
                            icon: Icons.assignment_rounded,
                            title: 'Kuesioner',
                            subtitle: 'Isi minat',
                            iconColor: const Color(0xFF0F766E),
                            iconBackground:
                                const Color(0xFFE5F3F1),

                            onTap: () {
                              _openKuesioner(context);
                            },
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _MenuCard(
                            icon: Icons.emoji_events_rounded,
                            title: 'Hasil',
                            subtitle: 'Rekomendasi',
                            iconColor: const Color(0xFFD99000),
                            iconBackground:
                                const Color(0xFFFFF3D9),

                            onTap: () {
                              _openHasil(context);
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [

                        Expanded(
                          child: _MenuCard(
                            icon: Icons.groups_rounded,
                            title: 'Ekskul',
                            subtitle: 'Daftar ekskul',
                            iconColor: const Color(0xFF5968C7),
                            iconBackground:
                                const Color(0xFFEAECFA),

                            onTap: () {
                              _openEkskul(context);
                            },
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _MenuCard(
                            icon: Icons.person_rounded,
                            title: 'Profil',
                            subtitle: 'Data akun',
                            iconColor: const Color(0xFFD45D64),
                            iconBackground:
                                const Color(0xFFFCE9EA),

                            onTap: () {
                              _openProfile(context);
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // =====================================================
                    // TENTANG
                    // =====================================================

                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          _openTentang(context);
                        },

                        style: TextButton.styleFrom(
                          foregroundColor:
                              const Color(0xFF8B95A5),

                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                        ),

                        icon: const Icon(
                          Icons.info_outline_rounded,
                          size: 17,
                        ),

                        label: const Text(
                          'Tentang MyEkskul',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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

// =====================================================================
// MENU CARD
// =====================================================================

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color iconBackground;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.iconBackground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),

        child: Container(
          constraints: const BoxConstraints(
            minHeight: 94,
          ),

          padding: const EdgeInsets.all(13),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),

            border: Border.all(
              color: const Color(0xFFE7EBF1),
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.025),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),

          child: Row(
            children: [

              Container(
                width: 43,
                height: 43,

                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(13),
                ),

                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF253044),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF9AA3B2),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 4),

              const Icon(
                Icons.chevron_right_rounded,
                size: 19,
                color: Color(0xFFB5BDCA),
              ),
            ],
          ),
        ),
      ),
    );
  }
}