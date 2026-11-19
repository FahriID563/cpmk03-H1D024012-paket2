import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/menu_adapter.dart';
import 'models/menu_model.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'services/hive_service.dart';

Future<void> main() async {
  // 1. Pastikan binding Flutter siap sebelum kode async
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inisialisasi Hive
  await Hive.initFlutter();

  // 3. Daftarkan adapter untuk class Menu jika belum terdaftar
  if (!Hive.isAdapterRegistered(MenuAdapter().typeId)) {
    Hive.registerAdapter(MenuAdapter());
  }

  // 4. Buka box jika belum terbuka
  if (!Hive.isBoxOpen(HiveService.boxName)) {
    await Hive.openBox<Menu>(HiveService.boxName);
  }

  // 5. Muat data dummy jika box masih kosong
  final hiveService = HiveService();
  await hiveService.seedInitialData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Menu Kafe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.brown,
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
    );
  }
}