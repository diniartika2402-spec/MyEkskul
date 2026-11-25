
import 'package:flutter/material.dart';

import 'kuesioner_page.dart';
import 'hasil_page.dart';
import 'ekstrakurikuler_page.dart';
import 'profile_page.dart';
import 'tentang_page.dart';
import '../auth/login_page.dart';
import 'kuesioner_intro_page.dart';

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

  static const Color navy = Color(0xFF172C3F);
  static const Color teal = Color(0xFF0F766E);
  static const Color mint = Color(0xFFE5F3F0);
  static const Color background = Color(0xFFF5F7F8);
  static const Color dark = Color(0xFF243447);
  static const Color muted = Color(0xFF8793A1);
  static const Color border = Color(0xFFE8EDF0);

  // NAVIGASI

  void openPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void openKuesioner(BuildContext context) {
  openPage(context, KuesionerIntroPage(userId: userId));
}

  void openHasil(BuildContext context) {
    openPage(context, HasilPage(userId: userId));
  }

  void openEkskul(BuildContext context) {
  openPage(
    context,
    EkstrakurikulerPage(
      userId: userId,
    ),
  );
}

  void openProfile(BuildContext context) {
    openPage(
      context,
      ProfilePage(
        userId: userId,
        nama: nama,
        email: email,
      ),
    );
  }

  void openTentang(BuildContext context) {
    openPage(context, const TentangPage());
  }

  Future<void> logout(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text('Konfirmasi Logout'),
        content: const Text(
          'Apakah kamu yakin ingin keluar dari akun MyEkskul?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (result != true || !context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  // HEADER

  Widget buildHeader(BuildContext context) {
    final firstName = nama.trim().isEmpty
        ? 'Siswa'
        : nama.trim().split(' ').first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF172C3F),
            Color(0xFF214B55),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MyEkskul',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'STUDENT PORTAL',
                      style: TextStyle(
                        color: Color(0xFFB5D3D0),
                        fontSize: 8,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.account_circle_outlined,
                  color: Colors.white,
                  size: 28,
                ),
                tooltip: 'Menu akun',
                onSelected: (value) {
                  if (value == 'profile') {
                    openProfile(context);
                  } else if (value == 'logout') {
                    logout(context);
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'profile',
                    child: Text('Profil Saya'),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          const Text(
            'SELAMAT DATANG KEMBALI',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1.6,
              color: Color(0xFF9FCAC3),
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Halo, $firstName!',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 29,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.7,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Saatnya mengenali potensi dan mengembangkan '
            'bakat terbaikmu.',
            style: TextStyle(
              color: Color(0xFFD1DFE3),
              fontSize: 12,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 23),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.09),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.10),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: Color(0xFF9FE0CE),
                  size: 18,
                ),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Kenali minatmu, temukan kegiatan favoritmu.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // REKOMENDASI

  Widget buildRecommendation(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: teal,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'LANGKAH PERTAMAMU',
                  style: TextStyle(
                    color: Color(0xFFC5EAE2),
                    fontSize: 9,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white.withOpacity(0.8),
                size: 21,
              ),
            ],
          ),

          const SizedBox(height: 13),

          const Text(
            'Sudah tahu ekskul\nyang cocok untukmu?',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.25,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Isi kuesioner dan dapatkan rekomendasi '
            'ekstrakurikuler berdasarkan minat dan bakatmu.',
            style: TextStyle(
              color: Color(0xFFD9F0EB),
              fontSize: 11,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 17),

          SizedBox(
            width: double.infinity,
            height: 43,
            child: ElevatedButton(
              onPressed: () => openKuesioner(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: teal,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mulai Kuesioner',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 8),
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
    );
  }

  // MENU ITEM

  Widget menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color iconBg,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 21,
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
                        color: dark,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: muted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFFABB5BE),
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // BUILD

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(context),

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  18, 25, 18, 25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildRecommendation(context),

                    const SizedBox(height: 27),

                    const Text(
                      'Jelajahi MyEkskul',
                      style: TextStyle(
                        color: dark,
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.4,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Pilih fitur yang ingin kamu akses.',
                      style: TextStyle(
                        color: muted,
                        fontSize: 11,
                      ),
                    ),

                    const SizedBox(height: 15),

                    menuItem(
                      icon: Icons.assignment_outlined,
                      title: 'Kuesioner Minat',
                      subtitle: 'Kenali minat dan bakatmu',
                      iconColor: teal,
                      iconBg: const Color(0xFFE3F2EF),
                      onTap: () => openKuesioner(context),
                    ),

                    const SizedBox(height: 10),

                    menuItem(
                      icon: Icons.emoji_events_outlined,
                      title: 'Hasil Rekomendasi',
                      subtitle: 'Lihat hasil rekomendasi ekskul',
                      iconColor: const Color(0xFFD18A18),
                      iconBg: const Color(0xFFFFF2D9),
                      onTap: () => openHasil(context),
                    ),

                    const SizedBox(height: 10),

                    menuItem(
                      icon: Icons.groups_outlined,
                      title: 'Daftar Ekstrakurikuler',
                      subtitle: 'Jelajahi kegiatan sekolah',
                      iconColor: const Color(0xFF5868C7),
                      iconBg: const Color(0xFFEAECFA),
                      onTap: () => openEkskul(context),
                    ),

                    const SizedBox(height: 10),

                    menuItem(
                      icon: Icons.person_outline_rounded,
                      title: 'Profil Saya',
                      subtitle: 'Lihat informasi akun',
                      iconColor: const Color(0xFFD45D64),
                      iconBg: const Color(0xFFFCE9EA),
                      onTap: () => openProfile(context),
                    ),

                    const SizedBox(height: 25),

                    // ABOUT

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F2F0),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.school_outlined,
                            color: teal,
                            size: 27,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tentang MyEkskul',
                                  style: TextStyle(
                                    color: navy,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Kenali platform pengembangan '
                                  'minat dan bakat siswa.',
                                  style: TextStyle(
                                    color: muted,
                                    fontSize: 10,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => openTentang(context),
                            icon: const Icon(
                              Icons.arrow_forward_rounded,
                              color: teal,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Center(
                      child: Text(
                        'MYEKSKUL • KEMBANGKAN POTENSIMU',
                        style: TextStyle(
                          color: muted,
                          fontSize: 9,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
