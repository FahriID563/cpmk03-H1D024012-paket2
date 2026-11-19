import 'dart:io';
import 'package:cpmk03_menu_kafe/models/menu_adapter.dart';
import 'package:cpmk03_menu_kafe/models/menu_model.dart';
import 'package:cpmk03_menu_kafe/services/hive_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory dir;
  final service = HiveService();

  setUpAll(() async {
    dir = await Directory.systemTemp.createTemp('hive_menu_test');
    Hive.init(dir.path);
    Hive.registerAdapter(MenuAdapter());
    await Hive.openBox<Menu>(HiveService.boxName);
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
    await dir.delete(recursive: true);
  });

  final kopi = Menu(
    id: '1',
    nama: 'Es Kopi Susu',
    kategori: 'Minuman',
    harga: 18000,
    deskripsi: 'Kopi robusta dengan susu segar dan gula aren',
    stokPorsi: 20,
    tersedia: true,
  );

  test('CREATE & READ', () async {
    await service.create(kopi);
    final all = service.getAll();
    expect(all.length, 1);
    expect(all.first.nama, 'Es Kopi Susu');
    expect(all.first.harga, 18000);
    expect(all.first.tersedia, true);
  });

  test('UPDATE', () async {
    await service.update(
      kopi.copyWith(harga: 20000, stokPorsi: 15, tersedia: false),
    );
    final all = service.getAll();
    expect(all.length, 1);
    expect(all.first.harga, 20000);
    expect(all.first.stokPorsi, 15);
    expect(all.first.tersedia, false);
  });

  test('Data tetap ada setelah box ditutup & dibuka lagi', () async {
    await Hive.box<Menu>(HiveService.boxName).close();
    await Hive.openBox<Menu>(HiveService.boxName);
    expect(service.getAll().first.nama, 'Es Kopi Susu');
    expect(service.getAll().first.harga, 20000);
  });

  test('DELETE', () async {
    await service.delete('1');
    expect(service.getAll(), isEmpty);
  });
}