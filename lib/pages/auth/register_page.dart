import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool isPasswordVisible = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // PROSES REGISTRASI
  // ============================================================

  Future<void> register() async {
    final nama = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Validasi nama
    if (nama.isEmpty) {
      _showMessage('Nama lengkap wajib diisi');
      return;
    }

    // Validasi email
    if (email.isEmpty) {
      _showMessage('Email wajib diisi');
      return;
    }

    // Validasi password
    if (password.isEmpty) {
      _showMessage('Password wajib diisi');
      return;
    }

    if (password.length < 6) {
      _showMessage('Password minimal 6 karakter');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
          'http://10.0.2.2/myekskul_api/auth/registrasi.php',
        ),
        body: {
          'nama': nama,
          'email': email,
          'password': password,
        },
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (data['success'] == true) {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Registrasi berhasil! Silakan login.',
            ),
            backgroundColor: Color(0xFF00897B),
          ),
        );

        // Kembali ke halaman login
        Navigator.pop(context);
      } else {
        setState(() {
          isLoading = false;
        });

        _showMessage(
          data['message'] ?? 'Registrasi gagal',
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _showMessage(
        'Tidak dapat terhubung ke server',
      );
    }
  }

  // ============================================================
  // MENAMPILKAN PESAN
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // ============================================================
  // INPUT FIELD
  // ============================================================

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,

      hintStyle: const TextStyle(
        fontSize: 13,
      ),

      prefixIcon: Icon(
        icon,
        color: const Color(0xFF00897B),
        size: 20,
      ),

      suffixIcon: suffixIcon,

      filled: true,

      fillColor: const Color(0xFFE0F2F1),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: Color(0xFF00897B),
          width: 1.3,
        ),
      ),

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
    );
  }

  // ============================================================
  // TAMPILAN
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: Container(
        width: double.infinity,
        height: double.infinity,

        // ======================================================
        // BACKGROUND HIJAU
        // ======================================================
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00695C),
              Color(0xFF00897B),
              Color(0xFF4DB6AC),
            ],
          ),
        ),

        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),

                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),

                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 12,
                      ),

                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: [

                          // ==================================================
                          // TOMBOL KEMBALI
                          // ==================================================
                          Align(
                            alignment: Alignment.centerLeft,

                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },

                              icon: const Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.white,
                                size: 25,
                              ),

                              style: IconButton.styleFrom(
                                backgroundColor:
                                    Colors.white.withOpacity(0.15),
                                padding:
                                    const EdgeInsets.all(8),
                              ),
                            ),
                          ),

                          const SizedBox(height: 3),

                          // ==================================================
                          // LOGO
                          // ==================================================
                          Container(
                            width: 65,
                            height: 65,

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(19),

                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.black.withOpacity(0.15),
                                  blurRadius: 15,
                                  offset: const Offset(0, 7),
                                ),
                              ],
                            ),

                            child: const Icon(
                              Icons.person_add_alt_1_rounded,
                              size: 35,
                              color: Color(0xFF00695C),
                            ),
                          ),

                          const SizedBox(height: 9),

                          // ==================================================
                          // NAMA APLIKASI
                          // ==================================================
                          const Text(
                            'MyEkskul',

                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            'Buat akun dan mulai temukan potensimu',

                            textAlign: TextAlign.center,

                            style: TextStyle(
                              color:
                                  Colors.white.withOpacity(0.9),
                              fontSize: 11.5,
                            ),
                          ),

                          const SizedBox(height: 14),

                          // ==================================================
                          // REGISTER CARD
                          // ==================================================
                          Container(
                            width: double.infinity,

                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(24),

                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.black.withOpacity(0.18),
                                  blurRadius: 25,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),

                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: [

                                // ==========================================
                                // JUDUL
                                // ==========================================
                                const Text(
                                  'Buat Akun ✨',

                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF263238),
                                  ),
                                ),

                                const SizedBox(height: 3),

                                Text(
                                  'Silakan isi data untuk membuat akun baru.',

                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),

                                const SizedBox(height: 14),

                                // ==========================================
                                // NAMA
                                // ==========================================
                                const Text(
                                  'Nama Lengkap',

                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF37474F),
                                  ),
                                ),

                                const SizedBox(height: 5),

                                SizedBox(
                                  height: 48,

                                  child: TextField(
                                    controller: nameController,

                                    textCapitalization:
                                        TextCapitalization.words,

                                    decoration: _inputDecoration(
                                      hint:
                                          'Masukkan nama lengkap',
                                      icon:
                                          Icons.person_outline_rounded,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 11),

                                // ==========================================
                                // EMAIL
                                // ==========================================
                                const Text(
                                  'Email',

                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF37474F),
                                  ),
                                ),

                                const SizedBox(height: 5),

                                SizedBox(
                                  height: 48,

                                  child: TextField(
                                    controller: emailController,

                                    keyboardType:
                                        TextInputType.emailAddress,

                                    decoration: _inputDecoration(
                                      hint: 'Masukkan email',
                                      icon:
                                          Icons.email_outlined,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 11),

                                // ==========================================
                                // PASSWORD
                                // ==========================================
                                const Text(
                                  'Password',

                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF37474F),
                                  ),
                                ),

                                const SizedBox(height: 5),

                                SizedBox(
                                  height: 48,

                                  child: TextField(
                                    controller:
                                        passwordController,

                                    obscureText:
                                        !isPasswordVisible,

                                    decoration:
                                        _inputDecoration(
                                      hint:
                                          'Minimal 6 karakter',

                                      icon:
                                          Icons.lock_outline_rounded,

                                      suffixIcon: IconButton(
                                        padding: EdgeInsets.zero,

                                        onPressed: () {
                                          setState(() {
                                            isPasswordVisible =
                                                !isPasswordVisible;
                                          });
                                        },

                                        icon: Icon(
                                          isPasswordVisible
                                              ? Icons
                                                  .visibility_outlined
                                              : Icons
                                                  .visibility_off_outlined,

                                          color:
                                              Colors.grey.shade600,

                                          size: 19,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // ==========================================
                                // BUTTON DAFTAR
                                // ==========================================
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,

                                  child: ElevatedButton(
                                    onPressed:
                                        isLoading
                                            ? null
                                            : register,

                                    style:
                                        ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFF00695C),

                                      foregroundColor:
                                          Colors.white,

                                      disabledBackgroundColor:
                                          const Color(0xFF80CBC4),

                                      elevation: 3,

                                      shape:
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(13),
                                      ),
                                    ),

                                    child: isLoading
                                        ? const SizedBox(
                                            width: 21,
                                            height: 21,

                                            child:
                                                CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,

                                            children: [
                                              Text(
                                                'Daftar',

                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                              ),

                                              SizedBox(width: 7),

                                              Icon(
                                                Icons
                                                    .arrow_forward_rounded,
                                                size: 18,
                                              ),
                                            ],
                                          ),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // ==========================================
                                // LINK LOGIN
                                // ==========================================
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,

                                  children: [
                                    Text(
                                      'Sudah punya akun?',

                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            Colors.grey.shade600,
                                      ),
                                    ),

                                    const SizedBox(width: 4),

                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },

                                      style:
                                          TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize
                                                .shrinkWrap,
                                      ),

                                      child: const Text(
                                        'Login sekarang',

                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight:
                                              FontWeight.bold,
                                          color:
                                              Color(0xFF00695C),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 9),

                          // ==================================================
                          // FOOTER
                          // ==================================================
                          Text(
                            '© MyEkskul • Temukan Potensimu',

                            style: TextStyle(
                              color:
                                  Colors.white.withOpacity(0.75),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}