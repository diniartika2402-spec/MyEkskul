import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'register_page.dart';
import '../user/dashboard_page.dart';
import '../admin/admin_dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // =========================================================
  // LOGIN
  // =========================================================
  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email dan password wajib diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
          'http://10.0.2.2/myekskul_api/auth/login.php',
        ),
        body: {
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        },
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (data['success'] == true) {
        final int userId = int.parse(data['id'].toString());
        final String nama = data['nama'].toString();
        final String email = data['email'].toString();
        final String role = data['role'].toString();

        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminDashboardPage(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardPage(
                userId: userId,
                nama: nama,
                email: email,
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ?? 'Email atau password salah',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak dapat terhubung ke server'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // =========================================================
  // BUILD
  // =========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // =====================================================
        // BACKGROUND HIJAU
        // =====================================================
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          // =================================================
                          // LOGO
                          // =================================================
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 15,
                                  offset: const Offset(0, 7),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.school_rounded,
                              size: 38,
                              color: Color(0xFF00695C),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // =================================================
                          // NAMA APLIKASI
                          // =================================================
                          const Text(
                            'MyEkskul',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            'Temukan ekstrakurikuler yang sesuai denganmu',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // =================================================
                          // LOGIN CARD
                          // =================================================
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.18),
                                  blurRadius: 25,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                // =========================================
                                // JUDUL
                                // =========================================
                                const Text(
                                  'Selamat Datang 👋',
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF263238),
                                  ),
                                ),

                                const SizedBox(height: 3),

                                Text(
                                  'Masuk untuk melanjutkan',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),

                                const SizedBox(height: 14),

                                // =========================================
                                // EMAIL
                                // =========================================
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
                                    decoration: InputDecoration(
                                      hintText: 'Masukkan email',
                                      hintStyle: const TextStyle(
                                        fontSize: 13,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.email_outlined,
                                        color: Color(0xFF00897B),
                                        size: 20,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFE0F2F1),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(13),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder:
                                          OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(13),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder:
                                          OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(13),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF00897B),
                                          width: 1.3,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 11),

                                // =========================================
                                // PASSWORD
                                // =========================================
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
                                    controller: passwordController,
                                    obscureText: !isPasswordVisible,
                                    decoration: InputDecoration(
                                      hintText: 'Masukkan password',
                                      hintStyle: const TextStyle(
                                        fontSize: 13,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.lock_outline_rounded,
                                        color: Color(0xFF00897B),
                                        size: 20,
                                      ),
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
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: Colors.grey.shade600,
                                          size: 19,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFE0F2F1),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(13),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder:
                                          OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(13),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder:
                                          OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(13),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF00897B),
                                          width: 1.3,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // =========================================
                                // BUTTON MASUK
                                // =========================================
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed:
                                        isLoading ? null : login,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFF00695C),
                                      foregroundColor: Colors.white,
                                      disabledBackgroundColor:
                                          const Color(0xFF80CBC4),
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
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
                                                'Masuk',
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

                                // =========================================
                                // REGISTER
                                // =========================================
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Belum punya akun?',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),

                                    const SizedBox(width: 4),

                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterPage(),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize
                                                .shrinkWrap,
                                      ),
                                      child: const Text(
                                        'Daftar sekarang',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF00695C),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          // =================================================
                          // FOOTER
                          // =================================================
                          Text(
                            '© MyEkskul • Temukan Potensimu',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
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