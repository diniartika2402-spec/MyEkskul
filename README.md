# MyEkskul

### Sistem Pemetaan Minat dan Rekomendasi Ekstrakurikuler Siswa Berbasis Mobile

MyEkskul adalah aplikasi mobile berbasis Flutter yang membantu siswa mengenal kegiatan ekstrakurikuler serta memperoleh pemetaan minat dan rekomendasi kegiatan sesuai hasil pengisian kuesioner.

## 📖 Deskripsi Proyek

MyEkskul dikembangkan menggunakan Flutter dan Dart untuk aplikasi mobile, PHP untuk backend/API, serta MySQL untuk penyimpanan data.

## ✨ Fitur Aplikasi

- Login dan registrasi pengguna.
- Menampilkan dashboard siswa.
- Menampilkan daftar ekstrakurikuler.
- Melihat detail ekstrakurikuler.
- Mengisi kuesioner pemetaan minat.
- Menampilkan hasil pemetaan minat dan rekomendasi ekstrakurikuler.
- Mendaftar ke Ekstrakulikuler
- Melihat dan mengelola profil pengguna.
- Memilih foto profil dari galeri perangkat.
- Menyediakan halaman Admin untuk pengelolaan data sesuai fitur yang tersedia.


## 🛠️ Teknologi yang Digunakan

| Teknologi | Kegunaan |
|---|---|
| Flutter | Pengembangan aplikasi mobile |
| Dart | Bahasa pemrograman aplikasi |
| PHP | Backend dan API |
| MySQL | Penyimpanan data |
| XAMPP | Menjalankan server lokal |
| Git dan GitHub | Pengelolaan versi kode |

## 📋 Persyaratan

- Flutter SDK dan Dart.
- Android Studio atau editor kode yang mendukung Flutter.
- Android Emulator atau perangkat Android.
- XAMPP dengan Apache dan MySQL.
- Backend/API dan database MyEkskul.

## 🚀 Cara Menjalankan Aplikasi

### 1. Clone repositori

```bash
git clone https://github.com/diniartika2402-spec/MyEkskul.git
cd MyEkskul
```

### 2. Instal dependensi

```bash
flutter pub get
```

### 3. Jalankan backend

1. Jalankan Apache dan MySQL melalui XAMPP.
2. Tempatkan backend/API pada direktori web server sesuai struktur proyek.
3. Buat atau impor database yang dibutuhkan.
4. Periksa konfigurasi koneksi database pada backend PHP.
5. Pastikan endpoint API dapat diakses.

### 4. Konfigurasi alamat API

Untuk Android Emulator, alamat `10.0.2.2` digunakan untuk mengakses localhost komputer host.

Contoh alamat dasar API:

```text
http://10.0.2.2/myekskul_api/
```


### 5. Jalankan aplikasi

Pastikan emulator atau perangkat Android sudah terhubung, kemudian jalankan:

```bash
flutter run
```

## 📸 Screenshot Aplikasi MyEkskul

### 1. Halaman Login
![Halaman Login](screenshots/login.png)

### 2. Halaman Registrasi
![Halaman Registrasi](screenshots/registrasi.png)

### 3. Dashboard Siswa
![Dashboard Siswa](screenshots/dashboard.png)

### 4. Halaman Profil
![Halaman Profil](screenshots/profil.png)

### 5. Halaman Kuesioner
![Halaman Kuesioner](screenshots/kuesioner.png)

### 6. Halaman Kuis
![Halaman Kuis](screenshots/kuis.png)

### 7. Hasil Pemetaan dan Rekomendasi
![Hasil Rekomendasi](screenshots/rekomendasi.png)

### 8. Daftar Ekstrakurikuler
![Daftar Ekstrakurikuler](screenshots/ekskul.png)

### 9. Detail Ekstrakurikuler
![Detail Ekstrakurikuler](screenshots/detail_ekskul.png)

### 10. Dashboard Admin
![Dashboard Admin](screenshots/dashboard_admin.png)

### 11. Kelola Ekstrakurikuler
![Kelola Ekstrakurikuler](screenshots/kelola_ekskul.png)

### 12. Kelola Pertanyaan
![Kelola Pertanyaan](screenshots/kelola_pertanyaan.png)

### 13. Halaman Tentang
![Halaman Tentang](screenshots/tentang.png)

## 📁 Struktur Proyek

```text
MyEkskul/
├── screenshots/
├── lib/
├── android/
├── pubspec.yaml
├── pubspec.lock
└── README.md
```

Struktur di atas merupakan gambaran umum proyek.

## 👩‍💻 Identitas Pengembang

- **Nama:** Dini Artika Rahmawati
- **NPM:** 2413025014
- **Program Studi:** Pendidikan Teknologi Informasi
- **Universitas:** Universitas Lampung
- **Proyek:** Sistem Pemetaan Minat dan Rekomendasi Ekstrakurikuler Siswa Berbasis Mobile

## 📌 Status Pengembangan

Aplikasi dikembangkan secara bertahap. Status setiap fitur didasarkan pada implementasi dan hasil pengujian aplikasi.

## 📄 Lisensi

Proyek ini dikembangkan untuk keperluan pembelajaran dan tugas akademik.
