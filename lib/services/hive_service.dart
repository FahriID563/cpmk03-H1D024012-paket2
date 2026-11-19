import 'package:hive/hive.dart';
import '../models/menu_model.dart';

/// Lapisan akses data (bagian dari MODEL pada MVC).
class HiveService {
  static const String boxName = 'menu_box';

  Box<Menu> get _box => Hive.box<Menu>(boxName);

  // READ
  List<Menu> getAll() => _box.values.toList();

  // CREATE (key = id menu)
  Future<void> create(Menu menu) => _box.put(menu.id, menu);

  // UPDATE (put dengan key yang sama menimpa data lama)
  Future<void> update(Menu menu) => _box.put(menu.id, menu);

  // DELETE
  Future<void> delete(String id) => _box.delete(id);
}