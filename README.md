# StudyLog — Aplikasi Catatan Perkuliahan

**StudyLog** adalah aplikasi manajemen catatan perkuliahan berbasis Flutter yang dirancang untuk membantu mahasiswa mengarsipkan materi kuliah secara terstruktur dan tetap dapat diakses tanpa koneksi internet (*offline-first*).

- **Tautan Demo Web (Mobile/Browser):** [https://curious-croquembouche-cfd02a.netlify.app](https://curious-croquembouche-cfd02a.netlify.app)

---

## Identitas & Kontribusi

- **Kelas:** IFB 5J
- **Program Studi / Institusi:** Informatika – Universitas Mulia
- **Mata Kuliah:** Pemrograman Aplikasi Bergerak
- **Anggota Kelompok & Peran:**
  - **Lukman Hermawan (2411005):** Arsitektur aplikasi, manajemen *state* (`Provider`), implementasi database lokal SQLite (`CRUD`), dan *build* multi-platform.
  - **Marsya Alvira (2411080):** Perancangan antarmuka pengguna (*UI/UX*), tata letak layar responsif, serta navigasi antarhalaman.
  - **Bilal Shabirin (2511095):** Pengujian fungsionalitas *CRUD* & validasi form, *unit testing* (`catatan_model_test.dart`), serta *debugging*.
  - **Nurul Farahdillah Sultan (2411038):** Penyusunan dokumentasi proyek (`README.md`), pengisian matriks uji & *logbook* Workbook, serta perekaman demo aplikasi.

---

## Fitur Utama

1. **Autentikasi & Profil Akademik:** Halaman masuk dengan validasi input serta tampilan profil mahasiswa.
2. **Manajemen Catatan Perkuliahan (CRUD Lengkap):**
   - **Create:** Menambah catatan baru berdasarkan mata kuliah, judul, isi materi, dan tanggal sesi.
   - **Read:** Menampilkan daftar catatan terurut dan halaman detail isi catatan.
   - **Update:** Menyunting judul maupun isi catatan yang sudah tersimpan.
   - **Delete:** Menghapus catatan dengan dialog konfirmasi keamanan.
3. **Penyimpanan Lokal Permanen (SQLite):** Menggunakan `sqflite` (Android/iOS) dan `sqflite_common_ffi` (Desktop Windows) sehingga data tetap tersimpan meskipun aplikasi ditutup sepenuhnya (*restart*).
4. **Pengingat Tugas & Jadwal Kuliah:** Fitur tambahan untuk memantau tenggat tugas dan jadwal perkuliahan.
5. **Antarmuka Responsif:** Menyesuaikan tata letak secara otomatis antara layar perangkat mobile dan desktop.

---

## Struktur Proyek

```text
lib/
├── data/
│   └── database_helper.dart       # Inisialisasi & skema tabel SQLite (studylog.db)
├── models/                        # Model data dan serialisasi toMap() / fromMap()
├── providers/
│   └── catatan_store.dart         # Pengelolaan state reaktif (ChangeNotifier)
├── screens/                       # Antarmuka pengguna (Login, Beranda, Daftar, Detail, Form)
├── viewmodels/                    # Logika penghubung UI dan penyimpanan data
└── main.dart                      # Entry point aplikasi & konfigurasi SQLite FFI
test/
└── catatan_model_test.dart        # Unit testing serialisasi model dan operasi store
```

---

## Cara Instalasi dan Menjalankan

### Prasyarat
- Flutter SDK (versi stabil)
- Dart SDK
- Visual Studio Code atau Android Studio
- Emulator Android, perangkat fisik (USB Debugging), atau kompiler C++ Windows

### Langkah Menjalankan
1. **Clone repositori ini:**
   ```bash
   git clone https://github.com/LukmanHmwn/studylog.git
   cd studylog
   ```
2. **Unduh dependensi paket:**
   ```bash
   flutter pub get
   ```
3. **Jalankan analisis kode dan unit test:**
   ```bash
   flutter analyze
   flutter test
   ```
4. **Jalankan aplikasi:**
   - Untuk perangkat/emulator Android:
```bash
flutter run
```
   - Untuk aplikasi mandiri Desktop Windows:
```bash
flutter build windows --release
```