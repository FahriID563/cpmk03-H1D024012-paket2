import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/menu_model.dart';
import '../routes/app_routes.dart';
import '../services/hive_service.dart';

/// CONTROLLER: penghubung antara View dan Model (Paket 2 - Menu Kafe).
class MenuKafeController extends GetxController {
  final HiveService _service = HiveService();

  // ================= STATE REAKTIF =================
  final menuList = <Menu>[].obs;
  final keyword = ''.obs;
  final selectedFilterKategori = 'Semua'.obs;

  // State khusus input Form
  final selectedKategoriForm = 'Makanan'.obs;
  final tersediaForm = true.obs;

  final List<String> daftarKategori = const [
    'Makanan',
    'Minuman',
    'Snack',
  ];

  final List<String> filterKategoriList = const [
    'Semua',
    'Makanan',
    'Minuman',
    'Snack',
  ];

  // ================= STATE FORM =================
  final formKey = GlobalKey<FormState>();
  final namaC = TextEditingController();
  final hargaC = TextEditingController();
  final deskripsiC = TextEditingController();
  final stokPorsiC = TextEditingController();

  /// null -> mode TAMBAH, berisi id -> mode EDIT
  String? editingId;
  bool get isEdit => editingId != null;

  // ================= GETTER FITUR KHUSUS =================
  /// Jumlah menu dengan status tersedia == true (untuk AppBar).
  int get jumlahTersedia => menuList.where((m) => m.tersedia).length;

  /// Total seluruh menu (untuk AppBar).
  int get totalMenu => menuList.length;

  /// Daftar menu yang sudah disaring berdasarkan ChoiceChip kategori & pencarian.
  List<Menu> get filteredList {
    final q = keyword.value.trim().toLowerCase();
    final filterKat = selectedFilterKategori.value;

    return menuList.where((m) {
      final cocokKategori = filterKat == 'Semua' || m.kategori == filterKat;
      final cocokKeyword = q.isEmpty ||
          m.nama.toLowerCase().contains(q) ||
          m.deskripsi.toLowerCase().contains(q);
      return cocokKategori && cocokKeyword;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  // ================= READ =================
  void loadData() {
    final data = _service.getAll()
      ..sort((a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()));
    menuList.assignAll(data);
  }

  // ================= DATA DUMMY =================
  Future<void> resetDummyData() async {
    await _service.seedInitialData(force: true);
    loadData();
    Get.snackbar(
      'Data Dummy',
      'Data dummy berhasil dimuat ulang',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ================= NAVIGASI KE FORM =================
  void openAddForm() {
    editingId = null;
    namaC.clear();
    hargaC.clear();
    deskripsiC.clear();
    stokPorsiC.clear();
    selectedKategoriForm.value = daftarKategori.first;
    tersediaForm.value = true;
    Get.toNamed(AppRoutes.form);
  }

  void openEditForm(Menu menu) {
    editingId = menu.id;
    namaC.text = menu.nama;
    hargaC.text = menu.harga.toStringAsFixed(0);
    deskripsiC.text = menu.deskripsi;
    stokPorsiC.text = menu.stokPorsi.toString();
    selectedKategoriForm.value = daftarKategori.contains(menu.kategori)
        ? menu.kategori
        : daftarKategori.first;
    tersediaForm.value = menu.tersedia;
    Get.toNamed(AppRoutes.form);
  }

  bool _isSaving = false;

  // ================= CREATE & UPDATE =================
  Future<void> save() async {
    if (_isSaving) return;
    if (formKey.currentState?.validate() == false) return;

    final nama = namaC.text.trim();

    // Aturan Paket 2: nama menu harus unik
    final namaSudahAda = menuList.any(
      (m) =>
          m.nama.trim().toLowerCase() == nama.toLowerCase() &&
          m.id != editingId,
    );
    if (namaSudahAda) {
      Get.snackbar(
        'Gagal',
        'Menu "$nama" sudah terdaftar',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    _isSaving = true;
    try {
      final menu = Menu(
        id: editingId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        nama: nama,
        kategori: selectedKategoriForm.value,
        harga: double.tryParse(hargaC.text.trim()) ?? 0.0,
        deskripsi: deskripsiC.text.trim(),
        stokPorsi: int.tryParse(stokPorsiC.text.trim()) ?? 0,
        tersedia: tersediaForm.value,
      );

      if (isEdit) {
        await _service.update(menu);
      } else {
        await _service.create(menu);
      }

      final pesan =
          isEdit ? 'Menu berhasil diperbarui' : 'Menu berhasil ditambahkan';
      loadData();
      tutup();
      Get.snackbar('Sukses', pesan, snackPosition: SnackPosition.BOTTOM);
    } finally {
      _isSaving = false;
    }
  }

  // ================= FITUR KHUSUS: TOGGLE TERSEDIA =================
  Future<void> toggleTersedia(Menu menu, bool nilaiBaru) async {
    final updated = menu.copyWith(tersedia: nilaiBaru);
    await _service.update(updated);
    loadData();
  }

  // ================= DELETE =================
  Future<void> confirmDelete(Menu menu) async {
    final yakin = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Hapus Menu'),
        content: Text('Yakin ingin menghapus "${menu.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => tutup(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => tutup(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (yakin == true) {
      await _service.delete(menu.id);
      loadData();
      Get.snackbar(
        'Terhapus',
        'Menu "${menu.nama}" telah dihapus',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ================= HELPER NAVIGASI & FORMAT =================
  /// Menutup halaman/dialog paling atas tanpa terhalang snackbar (GetX 4.x).
  void tutup<T>([T? result]) {
    if (Get.key.currentState?.canPop() ?? false) {
      Get.key.currentState?.pop<T>(result);
    } else {
      Get.back<T>(result: result);
    }
  }

  /// Mengubah angka double menjadi format Rupiah, mis. 15000 -> "Rp 15.000".
  String formatRupiah(double nilai) {
    final angka = nilai.round().toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final hasil = angka.replaceAllMapped(reg, (m) => '${m[1]}.');
    return 'Rp $hasil';
  }

  // ================= VALIDATOR (ATURAN PAKET 2) =================
  String? validateNama(String? v) {
    if (v == null || v.trim().isEmpty) return 'Nama menu wajib diisi';
    return null;
  }

  String? validateHarga(String? v) {
    final h = double.tryParse(v?.trim() ?? '');
    if (h == null) return 'Harga wajib berupa angka';
    if (h <= 0) return 'Harga harus lebih dari 0';
    return null;
  }

  String? validateDeskripsi(String? v) {
    if (v != null && v.trim().length > 100) {
      return 'Deskripsi maksimal 100 karakter';
    }
    return null;
  }

  String? validateStokPorsi(String? v) {
    final s = int.tryParse(v?.trim() ?? '');
    if (s == null) return 'Stok porsi wajib berupa angka';
    if (s < 0) return 'Stok porsi minimal 0';
    return null;
  }

  @override
  void onClose() {
    namaC.dispose();
    hargaC.dispose();
    deskripsiC.dispose();
    stokPorsiC.dispose();
    super.onClose();
  }
}