# AI Usage Declaration — MyEkskul

## 1. Tujuan Penggunaan AI

Dalam pengembangan aplikasi MyEkskul, saya menggunakan bantuan AI untuk membantu proses penulisan kode, implementasi fitur, dan pemecahan masalah teknis. Penggunaan AI dilakukan berdasarkan kebutuhan fitur dan alur aplikasi yang telah saya tentukan.

## 2. Daftar Alat AI

- **ChatGPT:** Membantu penyusunan kode program, penjelasan kode, dan penelusuran kesalahan selama pengembangan aplikasi.


## 3. Pembagian Peran dan Kontribusi

### Kontribusi Saya

- Menentukan kebutuhan dan tujuan aplikasi MyEkskul.
- Menentukan alur penggunaan aplikasi, mulai dari login dan registrasi, pengisian kuesioner minat, hingga penampilan hasil pemetaan dan rekomendasi ekstrakurikuler.
- Menentukan fitur yang dibutuhkan berdasarkan tujuan proyek.
- Melakukan pengujian aplikasi dan mengidentifikasi masalah yang muncul selama proses pengembangan.

### Kontribusi AI

- Membantu menghasilkan kode program untuk implementasi fitur aplikasi.
- Membantu menyusun antarmuka dan logika pemrosesan data.
- Membantu memberikan penjelasan serta saran untuk mengatasi kesalahan program.

Sebagian besar kode program dibuat dengan bantuan AI. Oleh karena itu, saya tidak mengklaim kode yang dihasilkan AI sebagai kode yang sepenuhnya saya tulis sendiri. Saya bertanggung jawab untuk memahami alur aplikasi, menguji hasil implementasi, dan menjelaskan kontribusi AI secara transparan.

## 4. Studi Kasus Prompting

### Studi Kasus 1 — Mengatasi Koneksi ke Server

**Kebutuhan:** Mengidentifikasi penyebab aplikasi tidak dapat terhubung ke server API.

**Prompt yang digunakan:**

> Apa penyebab aplikasi Flutter tidak terhubung ke server? Bantu periksa kemungkinan kesalahan pada alamat URL API dan konfigurasi koneksi.

**Hasil dan evaluasi:**

AI membantu menelusuri kemungkinan penyebab masalah koneksi. Dalam proses pengujian, saya menemukan bahwa masalah yang terjadi berkaitan dengan kesalahan penulisan alamat URL API, kemudian saya memperbaikinya.

**Penyesuaian dan pembelajaran:**

Saya menyadari bahwa saran AI perlu diverifikasi melalui pemeriksaan kode dan pengujian aplikasi. Perbaikan dilakukan berdasarkan masalah yang ditemukan pada proyek, bukan hanya dengan menerima saran AI secara langsung.

### Studi Kasus 2 — Menampilkan Hasil Rekomendasi

**Kebutuhan:** Mengambil data rekomendasi dari API dan menampilkannya pada aplikasi Flutter.

**prompt:**

> Bantu buat kode Flutter untuk mengambil data rekomendasi ekstrakurikuler dari API PHP menggunakan user_id, menangani status loading dan error, serta menampilkan hasil rekomendasi dalam bentuk daftar.

**Hasil dan evaluasi:**

AI membantu menghasilkan kode untuk proses pengambilan data dan tampilan rekomendasi. Salah satu contoh implementasinya terdapat pada file `hasil_page.dart`, khususnya fungsi `fetchRekomendasi` yang mengambil data dari endpoint rekomendasi.

**Penyesuaian dan pembelajaran:**

Kode perlu disesuaikan dengan alamat API, struktur respons JSON, dan endpoint yang digunakan oleh backend MyEkskul. Pengujian dilakukan untuk memastikan data rekomendasi dapat diterima dan ditampilkan sesuai hasil respons server.


## 5. Kesimpulan

AI digunakan sebagai alat bantu dalam proses pengembangan aplikasi MyEkskul, bukan sebagai pengganti evaluasi dan pengujian. Saya berupaya menggunakan AI secara transparan dengan membedakan kontribusi dalam perancangan kebutuhan aplikasi dari kode program yang dihasilkan dengan bantuan AI.