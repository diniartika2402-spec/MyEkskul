
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
  static const Color teal = Color(0xFF0F766E);
  static const Color background = Color(0xFFF4F7F7);

  static const String baseUrl =
      'http://10.0.2.2/myekskul_api';

  List<Map<String, dynamic>> questions = [];

  // Key = ID pertanyaan, value = nilai jawaban 1 sampai 5.
  final Map<int, int> answers = {};

  int currentIndex = 0;
  bool isLoading = true;
  bool isSaving = false;
  String errorMessage = '';

  final List<String> answerLabels = [
    'Sangat tidak suka',
    'Tidak suka',
    'Netral',
    'Suka',
    'Sangat suka',
  ];

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  // ============================================================
  // MENGAMBIL PERTANYAAN
  // ============================================================

  Future<void> fetchQuestions() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });
    }

    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/pertanyaan/get.php'),
          )
          .timeout(const Duration(seconds: 15));

      final dynamic data = jsonDecode(response.body);

      if (response.statusCode != 200 ||
          data is! Map ||
          data['success'] != true ||
          data['data'] is! List) {
        throw Exception(
          data is Map
              ? data['message'] ?? 'Pertanyaan gagal dimuat.'
              : 'Format respons server tidak valid.',
        );
      }

      final loadedQuestions =
          List<Map<String, dynamic>>.from(
        (data['data'] as List).map(
          (item) => Map<String, dynamic>.from(item),
        ),
      );

      if (!mounted) return;

      setState(() {
        questions = loadedQuestions;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage =
            'Gagal memuat pertanyaan. Periksa koneksi server.';
      });

      debugPrint('Error mengambil pertanyaan: $e');
    }
  }

  // ============================================================
  // MENYIMPAN JAWABAN
  // ============================================================

  Future<void> saveAnswers() async {
    if (widget.userId <= 0) {
      _showMessage(
        'ID pengguna tidak valid. Silakan login kembali.',
      );
      debugPrint('User ID tidak valid: ${widget.userId}');
      return;
    }

    if (answers.length < questions.length) {
      _showMessage(
        'Jawab semua pertanyaan terlebih dahulu.',
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      for (final question in questions) {
        final int questionId =
            int.parse(question['id'].toString());

        final int? answerValue = answers[questionId];

        if (answerValue == null) {
          throw Exception(
            'Jawaban pertanyaan $questionId belum dipilih.',
          );
        }

        debugPrint(
          'Menyimpan: user_id=${widget.userId}, '
          'pertanyaan_id=$questionId, nilai=$answerValue',
        );

        // Kirim sebagai form agar dapat dibaca oleh $_POST di PHP.
        final response = await http
            .post(
              Uri.parse('$baseUrl/pertanyaan/save.php'),
              body: {
                'user_id': widget.userId.toString(),
                'pertanyaan_id': questionId.toString(),
                'nilai': answerValue.toString(),
              },
            )
            .timeout(const Duration(seconds: 15));

        final dynamic data = jsonDecode(response.body);

        if (response.statusCode != 200 ||
            data is! Map ||
            data['success'] != true) {
          final message = data is Map
              ? data['message'] ?? 'Jawaban gagal disimpan.'
              : 'Respons server tidak valid.';

          throw Exception(message);
        }
      }

      if (!mounted) return;

      // Semua jawaban berhasil disimpan.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HasilPage(
            userId: widget.userId,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error menyimpan jawaban: $e');

      if (mounted) {
        _showMessage('Gagal menyimpan jawaban: $e');
      }
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // NAVIGASI PERTANYAAN
  // ============================================================

  void nextQuestion() {
    final question = questions[currentIndex];
    final int questionId =
        int.parse(question['id'].toString());

    if (!answers.containsKey(questionId)) {
      _showMessage('Silakan pilih salah satu jawaban.');
      return;
    }

    if (currentIndex < questions.length - 1) {
      setState(() => currentIndex++);
    } else {
      saveAnswers();
    }
  }

  void previousQuestion() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
    }
  }

  // ============================================================
  // TAMPILAN UTAMA
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        toolbarHeight: 48,
        backgroundColor: teal,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Kuesioner Minat',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: teal,
                ),
              )
            : errorMessage.isNotEmpty
                ? _buildError()
                : questions.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada pertanyaan tersedia.',
                        ),
                      )
                    : _buildQuestion(),
      ),
    );
  }

  // ============================================================
  // TAMPILAN ERROR
  // ============================================================

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 40,
              color: teal,
            ),
            const SizedBox(height: 10),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: fetchQuestions,
              style: ElevatedButton.styleFrom(
                backgroundColor: teal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TAMPILAN PERTANYAAN RINGKAS
  // ============================================================

  Widget _buildQuestion() {
    final question = questions[currentIndex];

    final int questionId =
        int.parse(question['id'].toString());

    final int? selectedValue = answers[questionId];

    final double progress =
        (currentIndex + 1) / questions.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(13, 10, 13, 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progres pertanyaan.
          Row(
            children: [
              Expanded(
                child: Text(
                  'Pertanyaan ${currentIndex + 1} '
                  'dari ${questions.length}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color: teal,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: const Color(0xFFDDE8E7),
              color: teal,
            ),
          ),

          const SizedBox(height: 10),

          // Kartu pertanyaan.
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFE1EAE9),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F3F0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${question['kategori'] ?? 'Umum'}',
                    style: const TextStyle(
                      color: teal,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '${question['pertanyaan'] ?? ''}',
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF203331),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Pilih satu jawaban yang paling sesuai.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 9),

          const Text(
            'Pilihan jawaban',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          // Kelima pilihan jawaban tampil sekaligus.
          ...List.generate(5, (index) {
            final int value = index + 1;
            final bool isSelected = selectedValue == value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: InkWell(
                onTap: () {
                  setState(() {
                    answers[questionId] = value;
                  });
                },
                borderRadius: BorderRadius.circular(10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: 38,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFE1F3EF)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? teal
                          : const Color(0xFFDCE5E4),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 23,
                        height: 23,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? teal
                              : const Color(0xFFF0F4F3),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : Text(
                                '$value',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF536360),
                                ),
                              ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          answerLabels[index],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? teal
                                : const Color(0xFF344441),
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: teal,
                          size: 17,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),

          const Spacer(),

          // Tombol navigasi.
          Row(
            children: [
              if (currentIndex > 0) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        isSaving ? null : previousQuestion,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: teal,
                      minimumSize: const Size(0, 39),
                      padding: EdgeInsets.zero,
                      side: const BorderSide(color: teal),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'sebelumnya',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: isSaving ? null : nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: teal,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 39),
                    padding: EdgeInsets.zero,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isSaving
                      ? const SizedBox(
                          width: 17,
                          height: 17,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          currentIndex == questions.length - 1
                              ? 'Selesai'
                              : 'Lanjutkan',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
