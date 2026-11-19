import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:cpmk03_menu_kafe/controllers/menu_controller.dart';
import 'package:cpmk03_menu_kafe/main.dart';
import 'package:cpmk03_menu_kafe/models/menu_adapter.dart';
import 'package:cpmk03_menu_kafe/models/menu_model.dart';
import 'package:cpmk03_menu_kafe/services/hive_service.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    Get.reset();
    tempDir = await Directory.systemTemp.createTemp('hive_test_');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(MenuAdapter().typeId)) {
      Hive.registerAdapter(MenuAdapter());
    }
    if (!Hive.isBoxOpen(HiveService.boxName)) {
      await Hive.openBox<Menu>(HiveService.boxName);
    }
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
    Get.reset();
  });

  testWidgets('Menu Kafe initial load smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Menu (0/0)'), findsOneWidget);
    expect(find.text('Belum ada data menu'), findsOneWidget);
    expect(find.text('Tambah'), findsOneWidget);
  });

  testWidgets('MenuKafeController CRUD and filter test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final controller = Get.find<MenuKafeController>();

    // 1. Tambah data menu baru
    controller.namaC.text = 'Kopi Espresso';
    controller.selectedKategoriForm.value = 'Minuman';
    controller.hargaC.text = '18000';
    controller.deskripsiC.text = 'Kopi hitam pekat segar';
    controller.stokPorsiC.text = '20';
    controller.tersediaForm.value = true;
    await controller.save();
    await tester.pumpAndSettle();

    expect(controller.totalMenu, 1);
    expect(controller.jumlahTersedia, 1);
    expect(find.text('Kopi Espresso'), findsOneWidget);
    expect(find.text('Menu (1/1)'), findsOneWidget);

    // 2. Tambah menu kedua (tidak tersedia)
    controller.namaC.text = 'Roti Bakar';
    controller.selectedKategoriForm.value = 'Makanan';
    controller.hargaC.text = '15000';
    controller.deskripsiC.text = 'Roti bakar cokelat keju';
    controller.stokPorsiC.text = '0';
    controller.tersediaForm.value = false;
    await controller.save();
    await tester.pumpAndSettle();

    expect(controller.totalMenu, 2);
    expect(controller.jumlahTersedia, 1);
    expect(find.text('Menu (1/2)'), findsOneWidget);

    // 3. Test toggle tersedia
    final espresso = controller.menuList.firstWhere((m) => m.nama == 'Kopi Espresso');
    await controller.toggleTersedia(espresso, false);
    await tester.pumpAndSettle();

    expect(controller.jumlahTersedia, 0);
    expect(find.text('Menu (0/2)'), findsOneWidget);

    // 4. Test filter kategori
    controller.selectedFilterKategori.value = 'Makanan';
    await tester.pumpAndSettle();
    expect(controller.filteredList.length, 1);
    expect(controller.filteredList.first.nama, 'Roti Bakar');

    controller.selectedFilterKategori.value = 'Semua';
    await tester.pumpAndSettle();
    expect(controller.filteredList.length, 2);

    // 5. Test search filter
    controller.keyword.value = 'Espresso';
    await tester.pumpAndSettle();
    expect(controller.filteredList.length, 1);
    expect(controller.filteredList.first.nama, 'Kopi Espresso');

    controller.keyword.value = '';
    await tester.pumpAndSettle();
    expect(controller.filteredList.length, 2);

    // 6. Test delete
    final roti = controller.menuList.firstWhere((m) => m.nama == 'Roti Bakar');
    final hiveService = HiveService();
    await hiveService.delete(roti.id);
    controller.loadData();
    await tester.pumpAndSettle();

    expect(controller.totalMenu, 1);
    expect(find.text('Roti Bakar'), findsNothing);
  });
}
