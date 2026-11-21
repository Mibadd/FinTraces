# PRD — FinTraces (Personal Finance App)

> **Product Requirements Document (PRD)** untuk aplikasi **FinTraces** — aplikasi manajemen keuangan pribadi berbasis Flutter. Dokumen ini menjadi acuan tunggal untuk melanjutkan pengembangan secara jelas dan terarah.

| Item | Keterangan |
|---|---|
| **Nama Produk** | FinTraces (package: `fintrace`) |
| **Platform** | Mobile (Android & iOS) — Flutter / Dart |
| **Versi saat ini** | 1.0.0+1 (tahap MVP / early development) |
| **Target pengguna** | Pengguna Indonesia (Rp, locale id_ID) |
| **Status data** | Offline-first, lokal (Isar DB), tanpa server |
| **Dokumen dibuat** | 2026-07-27 |

---

## 1. Ringkasan Produk (Overview)

FinTraces adalah aplikasi **manajemen keuangan pribadi** yang membantu pengguna mengelola anggaran bulanan, mengontrol pengeluaran harian, membangun kebiasaan menabung, dan merencanakan investasi jangka panjang — semuanya dalam satu aplikasi mobile yang privat dan berjalan offline.

Konsep inti aplikasi adalah **"Sisa Jatah Harian"**: alih-alih hanya mencatat pengeluaran, FinTraces secara otomatis menghitung berapa banyak uang yang boleh dibelanjakan hari ini agar target tabungan tetap tercapai di akhir bulan.

## 2. Latar Belakang & Masalah

- Banyak orang kesulitan mengetahui **berapa yang aman dibelanjakan setiap hari** tanpa mengganggu target tabungan.
- Aplikasi pencatat keuangan umumnya hanya mencatat *setelah* uang dikeluarkan, bukan memandu *sebelum* pengeluaran.
- Kebiasaan menabung sering gagal karena tabungan dipotong dari *sisa* uang, bukan di awal.

## 3. Tujuan Produk (Goals)

- [ ] Memberi pengguna angka jelas **"boleh belanja berapa hari ini"** secara real-time.
- [ ] Menerapkan prinsip **Pay Yourself First** — tabungan dipotong virtual di awal.
- [ ] Mempermudah pencatatan pengeluaran harian per kategori dalam hitungan detik.
- [ ] Membantu pengguna memproyeksikan pertumbuhan investasi dengan memperhitungkan inflasi.
- [ ] Menjaga privasi penuh: data keuangan tidak pernah keluar dari perangkat.

### Non-Goals (di luar cakupan saat ini)

- Sinkronisasi cloud / multi-device.
- Integrasi rekening bank / open banking otomatis.
- Fitur multi-user atau keuangan bersama (keluarga/tim).
- Multi-mata uang (fokus Rupiah).

## 4. Persona Pengguna

- **Pekerja muda bergaji bulanan** — ingin disiplin mengatur gaji agar tidak boros di awal bulan dan tetap bisa menabung.
- **Mahasiswa / fresh graduate** — baru belajar mengelola uang, butuh panduan sederhana "boleh belanja berapa hari ini".

## 5. Lingkup Fitur (Scope)

### 5.1 Modul yang Sudah Ada (Existing)

| Modul | Deskripsi | Status |
|---|---|---|
| **Budget / Dashboard** | Setup gaji & target tabungan, hitung sisa jatah harian & bulanan, input pengeluaran per kategori via numpad. | ✅ Dasar selesai |
| **Savings** | Menampilkan target tabungan & gaji, menjelaskan prinsip Pay Yourself First. | 🟡 Tampilan saja |
| **Investment Calculator** | Proyeksi bunga majemuk + setoran bulanan, hasil nominal & disesuaikan inflasi. | ✅ Fungsional |

### 5.2 Detail Fungsional per Fitur

#### A. Budget / Dashboard

- Saat pertama kali: pengguna memasukkan **Gaji Bulanan** dan **Target Tabungan** → membuat `BudgetSession`.
- Menampilkan **Sisa Jatah Hari Ini** dengan rumus:

```
Sisa Jatah Harian = (Gaji − Target Tabungan − Total Pengeluaran) ÷ Sisa Hari dalam Bulan
```

- Menampilkan **Sisa Bulanan** = Gaji − Target Tabungan − Total Pengeluaran.
- Tombol **Input** membuka bottom sheet: numpad + pilih kategori (Food, Transportation, Entertainment, Utilities, Others).
- Daftar transaksi **hari ini** dengan ikon kategori, jam, dan nominal.

#### B. Savings

- Menampilkan **Target Tabungan Bulanan** dan **Total Gaji**.
- Menjelaskan mekanisme tabungan dipotong virtual sebelum menghitung jatah harian.

#### C. Investment Calculator

- Input: Modal Awal, Setoran Bulanan, Durasi (tahun), Bunga Tahunan (%), Inflasi Tahunan (%).
- Output: **Nilai Masa Depan (Nominal)** dan **Nilai Disesuaikan Inflasi (Daya Beli Riil)**.
- Rumus: `FV = P(1+r)^n + PMT × (((1+r)^n − 1) / r)`, lalu didiskon dengan inflasi.

## 6. Backlog / Roadmap Pengembangan

> Prioritas berikut disusun dari temuan audit kode. Item ini yang perlu dikerjakan agar aplikasi benar-benar siap dipakai.

### Prioritas Tinggi (harus untuk rilis)

- [ ] Perbaiki entry point: `main.dart` masih menampilkan placeholder *"FinTrace Dashboard (Coming Soon)"* — sambungkan langsung ke `MainScreen`.
- [ ] Fitur **edit & hapus transaksi**.
- [ ] **Penanganan pergantian bulan** — otomatis buat session baru & reset pengeluaran tiap bulan.
- [ ] Validasi input (mis. target tabungan tidak boleh melebihi gaji).
- [ ] Simpan data sensitif dengan `flutter_secure_storage` yang sudah disiapkan tetapi belum dipakai.

### Prioritas Menengah

- [ ] Riwayat pengeluaran per bulan + ringkasan/grafik per kategori.
- [ ] Edit gaji / target tabungan setelah setup awal.
- [ ] Notifikasi/pengingat harian sisa jatah.
- [ ] Dukungan tema gelap penuh (dark theme sudah ada tapi perlu diuji).

### Prioritas Rendah (nice to have)

- [ ] Ekspor data (CSV / PDF).
- [ ] Backup & restore lokal.
- [ ] Kategori kustom buatan pengguna.

## 7. Arsitektur & Teknologi

| Area | Teknologi |
|---|---|
| Framework | Flutter (SDK ^3.11.3), Dart |
| State Management | flutter_riverpod |
| Database lokal | Isar + isar_flutter_libs |
| Penyimpanan aman | flutter_secure_storage |
| Utilitas | intl (format Rp), uuid, path_provider |
| Arsitektur | Clean Architecture (domain / data / presentation) |

### Struktur folder utama

```
lib/
├── core/          → database, routing, security, theme, widgets
└── features/
    ├── budget/    → domain, data, presentation (fitur inti)
    ├── savings/   → presentation
    └── calculator/→ presentation
```

## 8. Model Data

**BudgetSession**

- `id` (String), `totalSalary` (int), `savingsGoal` (int), `totalSpent` (int), `monthYear` (DateTime)
- Getter turunan: `remainingDailyLimit`, `remainingMonthlyBudget`

**Transaction**

- `id` (String), `amount` (int, Rupiah utuh), `category` (enum), `date` (DateTime)
- Kategori: `food`, `transportation`, `entertainment`, `utilities`, `others`

## 9. Metrik Keberhasilan (Success Metrics)

- Pengguna menyelesaikan setup budget di sesi pertama (activation rate).
- Frekuensi input transaksi harian (retention/engagement).
- Persentase pengguna yang mencapai target tabungan bulanan.
- Penggunaan kalkulator investasi sebagai indikator perencanaan jangka panjang.

## 10. Risiko & Catatan Audit

> Temuan dari audit kode yang perlu diperhatikan sebelum lanjut:

- README & `pubspec.yaml` masih template default ("A new Flutter project") — perlu deskripsi resmi.
- Data keuangan disimpan di Isar biasa, belum memanfaatkan secure storage yang sudah disiapkan.
- Belum ada penanganan reset bulanan → data pengeluaran akan menumpuk terus.
- Zip menyertakan folder build berat (`.dart_tool`, `android/build`, `.gradle`) yang sebaiknya di-`.gitignore`.
- Tidak ada unit/widget test — hanya template test bawaan Flutter.
