import 'package:get/get.dart';
import '../bindings/menu_binding.dart';
import '../views/menu_form_view.dart';
import '../views/menu_list_view.dart';
import 'app_routes.dart';

/// Pemetaan route -> halaman (+ binding).
class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const MenuListView(),
      binding: MenuBinding(),
    ),
    GetPage(
      name: AppRoutes.form,
      page: () => const MenuFormView(),
    ),
  ];
}