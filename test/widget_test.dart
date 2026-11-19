import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
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

  testWidgets('Navigate to Form when Tambah button is tapped', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Tambah Menu'), findsOneWidget);
    expect(find.text('Nama Menu'), findsOneWidget);
    expect(find.text('Kategori'), findsOneWidget);
    expect(find.text('Harga (Rp)'), findsOneWidget);
    expect(find.text('Stok Porsi'), findsOneWidget);
    expect(find.text('Deskripsi (maks. 100 karakter)'), findsOneWidget);
    expect(find.text('Tersedia'), findsOneWidget);
    expect(find.text('Simpan'), findsOneWidget);
  });
}
