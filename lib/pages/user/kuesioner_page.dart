import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'hasil_page.dart';

class KuesionerPage extends StatefulWidget {
  final int userId;

  const KuesionerPage({
    super.key,
    required this.userId,
  });

  @override
  State<KuesionerPage> createState() => _KuesionerPageState();
}

class _KuesionerPageState extends State<KuesionerPage> {
  bool isLoading = true;
  bool isSaving = false;

  String? errorMessage;

  List<dynamic> questions = [];

  // Menyimpan jawaban berdasarkan ID pertanyaan
  final Map<int, int> answers = {};

  // Nomor pertanyaan yang sedang ditampilkan
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  // ============================================================
  // MENGAMBIL PERTANYAAN
  // ============================================================

  Future<void> fetchQuestions() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://10.0.2.2/myekskul_api/pertanyaan/get.php',
        ),
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (data['success'] == true) {
        setState(() {
          questions = data['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Gagal mengambil pertanyaan';
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Tidak dapat terhubung ke server';
        isLoading = false;
      });
    }
  }

  // ============================================================
  // PINDAH KE PERTANYAAN BERIKUTNYA
  // ============================================================

  Future<void> nextQuestion() async {
    if (questions.isEmpty) return;

    final question = questions[currentIndex];

    final int questionId = int.parse(
      question['id'].toString(),
    );

    // Pastikan pertanyaan sudah dijawab
    if (!answers.containsKey(questionId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Silakan pilih jawaban terlebih dahulu.',
          ),
        ),
      );
      return;
    }

    // Kalau belum pertanyaan terakhir
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
      });

      return;
    }

    // Kalau sudah pertanyaan terakhir
    await saveAnswers();
  }

  // ============================================================
  // KEMBALI KE PERTANYAAN SEBELUMNYA
  // ============================================================

  void previousQuestion() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  // ============================================================
  // MENYIMPAN SEMUA JAWABAN
  // ============================================================

  Future<void> saveAnswers() async {
    // Pastikan semua pertanyaan sudah dijawab
    if (answers.length != questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Silakan jawab semua pertanyaan terlebih dahulu.',
          ),
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      for (final question in questions) {
        final int questionId = int.parse(
          question['id'].toString(),
        );

        final int nilai = answers[questionId]!;

        final response = await http.post(
          Uri.parse(
            'http://10.0.2.2/myekskul_api/pertanyaan/save.php',
          ),
          body: {
            'user_id': widget.userId.toString(),
            'pertanyaan_id': questionId.toString(),
            'nilai': nilai.toString(),
          },
        );

        final data = jsonDecode(response.body);

        if (data['success'] != true) {
          throw Exception(
            data['message'] ?? 'Gagal menyimpan jawaban',
          );
        }
      }

      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      // Masuk ke halaman hasil rekomendasi
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HasilPage(
            userId: widget.userId,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal menyimpan jawaban: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ============================================================
  // TAMPILAN
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kuesioner'),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.red,
            ),
          ),
        ),
      );
    }

    if (questions.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada pertanyaan.',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      );
    }

    final question = questions[currentIndex];

    final int questionId = int.parse(
      question['id'].toString(),
    );

    final bool isLastQuestion =
        currentIndex == questions.length - 1;

    final double progress =
        (currentIndex + 1) / questions.length;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======================================================
          // PROGRESS
          // ======================================================

          Text(
            'Pertanyaan ${currentIndex + 1} dari ${questions.length}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1976D2),
            ),
          ),

          const SizedBox(height: 10),

          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(0xFF1976D2),
            ),
          ),

          const SizedBox(height: 30),

          // ======================================================
          // KARTU PERTANYAAN
          // ======================================================

          Expanded(
            child: SingleChildScrollView(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1976D2)
                              .withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Text(
                          question['kategori']?.toString() ??
                              '-',
                          style: const TextStyle(
                            color: Color(0xFF1976D2),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      Text(
                        question['pertanyaan'].toString(),
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        'Seberapa sesuai dengan kamu?',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 12),

                      _buildAnswerOption(
                        questionId: questionId,
                        value: 1,
                        text: 'Sangat Tidak Suka',
                      ),

                      _buildAnswerOption(
                        questionId: questionId,
                        value: 2,
                        text: 'Tidak Suka',
                      ),

                      _buildAnswerOption(
                        questionId: questionId,
                        value: 3,
                        text: 'Netral',
                      ),

                      _buildAnswerOption(
                        questionId: questionId,
                        value: 4,
                        text: 'Suka',
                      ),

                      _buildAnswerOption(
                        questionId: questionId,
                        value: 5,
                        text: 'Sangat Suka',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // ======================================================
          // TOMBOL NAVIGASI
          // ======================================================

          Row(
            children: [
              if (currentIndex > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: isSaving
                        ? null
                        : previousQuestion,
                    style: OutlinedButton.styleFrom(
                      minimumSize:
                          const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Kembali',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              if (currentIndex > 0)
                const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    minimumSize:
                        const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),
                  child: isSaving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          isLastQuestion
                              ? 'Selesai'
                              : 'Lanjut',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // ============================================================
  // PILIHAN JAWABAN
  // ============================================================

  Widget _buildAnswerOption({
    required int questionId,
    required int value,
    required String text,
  }) {
    return RadioListTile<int>(
      value: value,
      groupValue: answers[questionId],
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      dense: true,
      activeColor: const Color(0xFF1976D2),
      onChanged: (selectedValue) {
        if (selectedValue == null) return;

        setState(() {
          answers[questionId] = selectedValue;
        });
      },
    );
  }
}