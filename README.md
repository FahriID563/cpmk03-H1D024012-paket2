# Aplikasi Menu Kafe (CPMK 03 - Paket 2)

- **Nama**: Mhd Fahri Irfandi Dewantara
- **NIM**: H1D024012
- **Paket**: Paket 2 — Menu Kafe

## Deskripsi Aplikasi
Aplikasi mobile Flutter untuk mengelola daftar menu kafe menggunakan arsitektur **MVC**, state management & routing **GetX**, serta penyimpanan lokal offline **Hive**.

### Fitur Utama & Khusus Paket 2
- CRUD lengkap (Tambah, Tampil, Ubah, Hapus dengan dialog konfirmasi) + Pencarian.
- Validasi form (nama unik, harga > 0 format Rupiah, deskripsi maks. 100 karakter, stok porsi >= 0).
- Switch status **Tersedia** langsung dari halaman daftar.
- Filter kategori menggunakan **ChoiceChip** (Semua / Makanan / Minuman / Snack).
- **AppBar** menampilkan jumlah menu tersedia secara reaktif, mis. `Menu (8/10)`.

## Link Video Penjelasan
https://youtu.be/cBB3rzwqQNM

## Cara Menjalankan
```bash
flutter pub get
flutter test
flutter run
