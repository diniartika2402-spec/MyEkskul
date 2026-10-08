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

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Validasi input
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email dan password harus diisi'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Kirim email dan password ke API
      final response = await http.post(
        Uri.parse(
          'http://10.0.2.2/myekskul_api/auth/login.php',
        ),
        body: {
          'email': email,
          'password': password,
        },
      );

      // Cek response dari server
      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (data['success'] == true) {
        // ======================================================
        // AMBIL DATA USER DARI RESPONSE API
        // ======================================================

        final userData = data['data'];

        final int userId = int.parse(
          userData['id'].toString(),
        );

        final String nama = userData['nama'].toString();
        final String userEmail = userData['email'].toString();
        final String role = userData['role'].toString();

        // ======================================================
        // LOGIN BERHASIL
        // ======================================================

        if (role == 'admin') {
          // Masuk ke dashboard admin
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const AdminDashboardPage(),
            ),
          );
        } else {
          // ====================================================
          // USER BIASA
          // ID USER DIKIRIM KE DASHBOARD
          // ====================================================

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => DashboardPage(
  userId: userId,
  nama: nama,
  email: userEmail,
),
            ),
          );
        }

        // Supaya variabel tidak dianggap tidak digunakan
        debugPrint('Login berhasil');
        debugPrint('User ID   : $userId');
        debugPrint('Nama      : $nama');
        debugPrint('Email     : $userEmail');
        debugPrint('Role      : $role');
      } else {
        // ======================================================
        // LOGIN GAGAL
        // ======================================================

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ?? 'Email atau password salah',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tidak dapat terhubung ke server: $e',
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // LOGO
                // ==================================================

                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1976D2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          color: Colors.white,
                          size: 45,
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'MyEkskul',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1976D2),
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        'Sistem Pemetaan Minat Ekstrakurikuler',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 45),

                // ==================================================
                // JUDUL
                // ==================================================

                const Text(
                  'Selamat Datang!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Silakan masuk ke akun kamu untuk melanjutkan.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 28),

                // ==================================================
                // EMAIL
                // ==================================================

                const Text(
                  'Email',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Masukkan email',
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // PASSWORD
                // ==================================================

                const Text(
                  'Password',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Masukkan password',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible =
                              !isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ==================================================
                // TOMBOL MASUK
                // ==================================================

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Masuk',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // REGISTER
                // ==================================================

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum punya akun? ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Daftar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}