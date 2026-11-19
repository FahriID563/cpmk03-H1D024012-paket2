import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/menu_controller.dart';

/// VIEW: halaman daftar menu (READ, Search, Filter, Toggle Tersedia, Edit/Hapus).
class MenuListView extends GetView<MenuKafeController> {
  const MenuListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Fitur khusus 3: tampilkan jumlah menu yang tersedia di AppBar
        title: Obx(
          () => Text('Menu (${controller.jumlahTersedia}/${controller.totalMenu})'),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Kolom pencarian
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: TextField(
              onChanged: (v) => controller.keyword.value = v,
              decoration: const InputDecoration(
                hintText: 'Cari nama atau deskripsi menu...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // Fitur khusus 2: filter kategori menggunakan ChoiceChip
          SizedBox(
            height: 44,
            child: Obx(
              () => ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: controller.filterKategoriList.map((kategori) {
                  final isSelected =
                      controller.selectedFilterKategori.value == kategori;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(kategori),
                      selected: isSelected,
                      onSelected: (_) =>
                          controller.selectedFilterKategori.value = kategori,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Daftar data reaktif
          Expanded(
            child: Obx(() {
              final data = controller.filteredList;
              if (data.isEmpty) {
                return const Center(
                  child: Text('Belum ada data menu'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final menu = data[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                child: Text(
                                  menu.nama.isNotEmpty
                                      ? menu.nama[0].toUpperCase()
                                      : '?',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      menu.nama,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    Text(
                                      '${menu.kategori} • ${controller.formatRupiah(menu.harga)} • Stok: ${menu.stokPorsi}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              // Fitur khusus 1: Switch "tersedia" langsung di daftar
                              Switch(
                                value: menu.tersedia,
                                onChanged: (val) =>
                                    controller.toggleTersedia(menu, val),
                              ),
                            ],
                          ),
                          if (menu.deskripsi.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              menu.deskripsi,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                menu.tersedia ? 'Tersedia' : 'Habis / Tidak Tersedia',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: menu.tersedia
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.orange,
                                    ),
                                    onPressed: () =>
                                        controller.openEditForm(menu),
                                  ),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        controller.confirmDelete(menu),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.openAddForm,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}