# MyEkskul

**Aplikasi Informasi dan Pengelolaan Ekstrakurikuler Sekolah**

## 📖 Deskripsi

MyEkskul adalah aplikasi berbasis Flutter yang dikembangkan untuk membantu pengguna melihat informasi kegiatan ekstrakurikuler sekolah. Aplikasi ini menyediakan halaman daftar ekstrakurikuler, detail kegiatan, dan profil pengguna.

Aplikasi menggunakan backend PHP dan database MySQL untuk mendukung pengelolaan serta pengambilan data.

## ✨ Fitur

- Menampilkan daftar ekstrakurikuler.
- Mencari ekstrakurikuler.
- Melihat detail informasi ekstrakurikuler.
- Mengelola profil pengguna.
- Memilih dan menghapus foto profil.
- Mengisi dan menyimpan jawaban kuesioner.

## 🛠️ Teknologi

- **Flutter** — pengembangan antarmuka aplikasi.
- **Dart** — bahasa pemrograman aplikasi.
- **PHP** — backend/API.
- **MySQL** — basis data.
- **XAMPP** — lingkungan server lokal untuk pengembangan.

## 📋 Persyaratan

Pastikan perangkat pengembangan telah memiliki:

- Flutter SDK dan Dart.
- Android Studio atau editor yang mendukung Flutter.
- XAMPP dengan Apache dan MySQL.
- Emulator Android atau perangkat Android.

## 🚀 Cara Menjalankan

### 1. Clone repository

```bash
git clone https://github.com/diniartika2402-spec/MyEkskul.git
cd MyEkskul
```

### 2. Pasang dependensi Flutter

```bash
flutter pub get
```

### 3. Jalankan backend

- Jalankan Apache dan MySQL melalui XAMPP.
- Letakkan folder backend `myekskul_api` di direktori web server XAMPP, jika belum tersedia di sana.
- Siapkan database MySQL sesuai konfigurasi backend.
- Pastikan alamat endpoint API di aplikasi sesuai dengan lingkungan yang digunakan.

Untuk Android Emulator, alamat server lokal komputer biasanya diakses melalui `http://10.0.2.2/`.

### 4. Jalankan aplikasi

Hubungkan perangkat Android atau nyalakan emulator, lalu jalankan:

```bash
flutter run
```

## 📁 Struktur Proyek

```text
MyEkskul/
├── android/
├── lib/
│   └── pages/
├── linux/
├── macos/
├── windows/
├── pubspec.yaml
└── README.md
```

## 👩‍💻 Pengembang

- **Nama:** Dini Artrika Rahmawati
- **NPM:** 2413025014
- **Program Studi:** PENDIDIKAN TEKNOLOGI INFORMASI
- **Mata Kuliah:** MOBILE PROGRAMMING

## 📄 Lisensi

Proyek ini dikembangkan untuk keperluan pembelajaran dan tugas akademik.
