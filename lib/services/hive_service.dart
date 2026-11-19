import 'package:hive/hive.dart';
import '../models/menu_model.dart';

/// Lapisan akses data (bagian dari MODEL pada MVC).
class HiveService {
  static const String boxName = 'menu_box';

  Box<Menu> get _box => Hive.box<Menu>(boxName);

  // READ
  List<Menu> getAll() => _box.values.whereType<Menu>().toList();

  // CREATE (key = id menu)
  Future<void> create(Menu menu) => _box.put(menu.id, menu);

  // UPDATE (put dengan key yang sama menimpa data lama)
  Future<void> update(Menu menu) => _box.put(menu.id, menu);

  // DELETE
  Future<void> delete(String id) => _box.delete(id);

  // SEED DUMMY DATA
  Future<void> seedInitialData({bool force = false}) async {
    final current = _box.values.whereType<Menu>().toList();
    if (current.isEmpty || force) {
      if (_box.isNotEmpty) {
        await _box.clear();
      }
      final Map<String, Menu> dummyEntries = {
        '1': Menu(
          id: '1',
          nama: 'Es Kopi Susu Gula Aren',
          kategori: 'Minuman',
          harga: 18000,
          deskripsi: 'Espresso dengan susu segar dan gula aren pilihan',
          stokPorsi: 25,
          tersedia: true,
        ),
        '2': Menu(
          id: '2',
          nama: 'Matcha Latte',
          kategori: 'Minuman',
          harga: 22000,
          deskripsi: 'Matcha murni dengan steamed milk yang lembut',
          stokPorsi: 15,
          tersedia: true,
        ),
        '3': Menu(
          id: '3',
          nama: 'Americano Ice',
          kategori: 'Minuman',
          harga: 16000,
          deskripsi: 'Double shot espresso dingin penyegar hari',
          stokPorsi: 0,
          tersedia: false,
        ),
        '4': Menu(
          id: '4',
          nama: 'Nasi Goreng Spesial',
          kategori: 'Makanan',
          harga: 28000,
          deskripsi: 'Nasi goreng harum dengan telur dan potongan ayam',
          stokPorsi: 12,
          tersedia: true,
        ),
        '5': Menu(
          id: '5',
          nama: 'Spaghetti Bolognese',
          kategori: 'Makanan',
          harga: 32000,
          deskripsi: 'Pasta klasik Italia dengan saus daging sapi gurih',
          stokPorsi: 8,
          tersedia: true,
        ),
        '6': Menu(
          id: '6',
          nama: 'Croissant Butter',
          kategori: 'Snack',
          harga: 15000,
          deskripsi: 'Pastry renyah beraroma butter khas Prancis',
          stokPorsi: 10,
          tersedia: true,
        ),
        '7': Menu(
          id: '7',
          nama: 'Kentang Goreng Truffle',
          kategori: 'Snack',
          harga: 20000,
          deskripsi: 'French fries renyah dengan aroma truffle harum',
          stokPorsi: 0,
          tersedia: false,
        ),
      };

      await _box.putAll(dummyEntries);
    }
  }
}