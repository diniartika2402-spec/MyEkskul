
import 'package:flutter/material.dart';

class PendaftaranPage extends StatefulWidget {
  final String namaEkskul;
  final int userId;
  final int ekskulId;

  const PendaftaranPage({
  super.key,
  required this.namaEkskul,
  required this.userId,
  required this.ekskulId,
});

  @override
  State<PendaftaranPage> createState() =>
      _PendaftaranPageState();
}

class _PendaftaranPageState extends State<PendaftaranPage> {
  static const Color teal = Color(0xFF0F766E);
  static const Color tealDark = Color(0xFF115E59);
  static const Color background = Color(0xFFF4F7F7);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController =
      TextEditingController();
  final TextEditingController _nisController =
      TextEditingController();
  final TextEditingController _kelasController =
      TextEditingController();
  final TextEditingController _noHpController =
      TextEditingController();
  final TextEditingController _alasanController =
      TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    _namaController.dispose();
    _nisController.dispose();
    _kelasController.dispose();
    _noHpController.dispose();
    _alasanController.dispose();
    super.dispose();
  }

  void _kirimPendaftaran() {
    if (!_formKey.currentState!.validate()) return;

    // Integrasi API pendaftaran akan ditambahkan
    // setelah menyesuaikan endpoint PHP.

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Formulir berhasil divalidasi. '
          'Selanjutnya hubungkan dengan API.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: teal,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Pendaftaran Ekskul',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),

                const SizedBox(height: 22),

                const Text(
                  'Data Diri Siswa',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF203331),
                  ),
                ),

                const SizedBox(height: 14),

                _buildInput(
                  controller: _namaController,
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama lengkap',
                  icon: Icons.person_outline_rounded,
                ),

                _buildInput(
                  controller: _nisController,
                  label: 'NIS',
                  hint: 'Masukkan nomor induk siswa',
                  icon: Icons.badge_outlined,
                  keyboardType: TextInputType.number,
                ),

                _buildInput(
                  controller: _kelasController,
                  label: 'Kelas',
                  hint: 'Contoh: XI RPL 1',
                  icon: Icons.school_outlined,
                ),

                _buildInput(
                  controller: _noHpController,
                  label: 'Nomor HP',
                  hint: 'Masukkan nomor HP aktif',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 12),

                const Text(
                  'Pilihan Ekstrakurikuler',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF203331),
                  ),
                ),

                const SizedBox(height: 14),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFE2EAE8),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.groups_rounded,
                        color: teal,
                        size: 25,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ekstrakurikuler yang dipilih',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              widget.namaEkskul,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: tealDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.check_circle_rounded,
                        color: teal,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  'Alasan Mengikuti',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF203331),
                  ),
                ),

                const SizedBox(height: 14),

                _buildInput(
                  controller: _alasanController,
                  label: 'Alasan',
                  hint: 'Tuliskan alasan kamu ingin mengikuti '
                      'ekstrakurikuler ini...',
                  icon: Icons.edit_note_rounded,
                  maxLines: 4,
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCCFBF1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: tealDark,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Pastikan seluruh data yang kamu isi '
                          'sudah benar sebelum mengirim '
                          'formulir pendaftaran.',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.6,
                            color: tealDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed:
                        isLoading ? null : _kirimPendaftaran,
                    icon: const Icon(
                      Icons.send_rounded,
                      size: 19,
                    ),
                    label: const Text(
                      'Kirim Pendaftaran',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: teal,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [teal, tealDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.assignment_rounded,
            color: Colors.white,
            size: 35,
          ),
          SizedBox(height: 13),
          Text(
            'Formulir Pendaftaran Siswa',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 7),
          Text(
            'Lengkapi data diri kamu untuk mengikuti '
            'kegiatan ekstrakurikuler di sekolah.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            textCapitalization: TextCapitalization.sentences,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '$label wajib diisi';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              prefixIcon: Icon(
                icon,
                color: teal,
                size: 21,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFFE2EAE8),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFFE2EAE8),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: teal,
                  width: 1.4,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
