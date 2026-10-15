
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatefulWidget {
  final int userId;
  final String nama;
  final String email;

  const ProfilePage({
    super.key,
    required this.userId,
    required this.nama,
    required this.email,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const Color primary = Color(0xFF0F766E);
  static const Color dark = Color(0xFF115E59);
  static const Color background = Color(0xFFF4F7F8);

  String? _fotoPath;
  bool _memuatFoto = true;
  bool _memilihFoto = false;

  @override
  void initState() {
    super.initState();
    _muatFoto();
  }

  Future<File> _fileFotoTersimpan() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/foto_profil_${widget.userId}.jpg');
  }

  Future<void> _muatFoto() async {
    try {
      final file = await _fileFotoTersimpan();

      if (!mounted) return;

      setState(() {
        _fotoPath = file.existsSync() ? file.path : null;
        _memuatFoto = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _memuatFoto = false);
    }
  }

  Future<void> _pilihFoto() async {
    if (_memilihFoto) return;

    setState(() => _memilihFoto = true);

    try {
      final picker = ImagePicker();
      final XFile? hasil = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
      );

      if (hasil == null) return;

      final fileTujuan = await _fileFotoTersimpan();

      await File(hasil.path).copy(fileTujuan.path);

      if (!mounted) return;

      setState(() {
        _fotoPath = fileTujuan.path;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto profil berhasil diperbarui'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto gagal disimpan. Silakan coba lagi.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _memilihFoto = false);
      }
    }
  }

  Future<void> _hapusFoto() async {
    try {
      final file = await _fileFotoTersimpan();

      if (await file.exists()) {
        await file.delete();
      }

      if (!mounted) return;

      setState(() => _fotoPath = null);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto profil dihapus'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto gagal dihapus'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _tampilkanMenuFoto() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Foto Profil',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: primary,
                  ),
                  title: const Text('Pilih dari galeri'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pilihFoto();
                  },
                ),
                if (_fotoPath != null)
                  ListTile(
                    leading: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    title: const Text('Hapus foto profil'),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _hapusFoto();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tinggi = MediaQuery.sizeOf(context).height;
    final compact = tinggi < 700;

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
            final avatarSize = compact ? 62.0 : 72.0;

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
                      vertical: compact ? 10 : 14,
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
                        GestureDetector(
                          onTap: _tampilkanMenuFoto,
                          child: SizedBox(
                            width: avatarSize + 12,
                            height: avatarSize + 12,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: avatarSize,
                                  height: avatarSize,
                                  margin: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.16),
                                    border: Border.all(
                                      color: Colors.white70,
                                      width: 1.8,
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: _buildAvatar(),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 27,
                                    height: 27,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: primary,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: _memilihFoto
                                        ? const Padding(
                                            padding: EdgeInsets.all(6),
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: primary,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.camera_alt_rounded,
                                            size: 15,
                                            color: primary,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: compact ? 6 : 9),
                        Text(
                          widget.nama.trim().isEmpty
                              ? 'Pengguna MyEkskul'
                              : widget.nama.trim(),
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
                          widget.email.trim().isEmpty
                              ? 'Email belum tersedia'
                              : widget.email.trim(),
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
                        const SizedBox(height: 3),
                        TextButton(
                          onPressed: _tampilkanMenuFoto,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            minimumSize: const Size(0, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Ubah foto profil',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: compact ? 12 : 18),

                  const Row(
                    children: [
                      Icon(
                        Icons.manage_accounts_outlined,
                        color: primary,
                        size: 22,
                      ),
                      SizedBox(width: 9),
                      Text(
                        'Informasi Akun',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF172B3A),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: compact ? 8 : 10),

                  _InfoCard(
                    icon: Icons.badge_outlined,
                    title: 'ID Pengguna',
                    value: widget.userId.toString(),
                    compact: compact,
                  ),
                  SizedBox(height: compact ? 6 : 8),
                  _InfoCard(
                    icon: Icons.person_outline_rounded,
                    title: 'Nama Lengkap',
                    value: widget.nama.trim().isEmpty
                        ? 'Nama belum tersedia'
                        : widget.nama.trim(),
                    compact: compact,
                  ),
                  SizedBox(height: compact ? 6 : 8),
                  _InfoCard(
                    icon: Icons.email_outlined,
                    title: 'Alamat Email',
                    value: widget.email.trim().isEmpty
                        ? 'Email belum tersedia'
                        : widget.email.trim(),
                    compact: compact,
                  ),

                  const Spacer(),

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
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: dark,
                          size: 19,
                        ),
                        SizedBox(width: 8),
                        Expanded(
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

  Widget _buildAvatar() {
    if (_memuatFoto) {
      return const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        ),
      );
    }

    if (_fotoPath != null && File(_fotoPath!).existsSync()) {
      return Image.file(
        File(_fotoPath!),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildInitial(),
      );
    }

    return _buildInitial();
  }

  Widget _buildInitial() {
    final initial = widget.nama.trim().isEmpty
        ? '?'
        : widget.nama.trim()[0].toUpperCase();

    return Center(
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 27,
          fontWeight: FontWeight.bold,
          color: Colors.white,
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
