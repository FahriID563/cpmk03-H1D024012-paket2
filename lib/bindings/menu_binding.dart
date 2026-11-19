import 'package:get/get.dart';
import '../controllers/menu_controller.dart';

/// Binding: mendaftarkan dependency controller ke GetX sebelum halaman dibuka.
class MenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenuKafeController>(() => MenuKafeController());
  }
}