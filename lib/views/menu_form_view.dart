import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/menu_controller.dart';

/// VIEW: halaman form untuk CREATE dan UPDATE menu kafe.
class MenuFormView extends GetView<MenuKafeController> {
  const MenuFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEdit ? 'Edit Menu' : 'Tambah Menu'),
      ),
      body: Form(
        key: controller.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: controller.namaC,
              textCapitalization: TextCapitalization.words,
              validator: controller.validateNama,
              decoration: const InputDecoration(
                labelText: 'Nama Menu',
                prefixIcon: Icon(Icons.restaurant_menu),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => DropdownButtonFormField<String>(
                key: ValueKey(controller.selectedKategoriForm.value),
                initialValue: controller.selectedKategoriForm.value,
                items: controller.daftarKategori
                    .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) controller.selectedKategoriForm.value = v;
                },
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.hargaC,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: controller.validateHarga,
              decoration: const InputDecoration(
                labelText: 'Harga (Rp)',
                prefixIcon: Icon(Icons.payments),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.stokPorsiC,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: controller.validateStokPorsi,
              decoration: const InputDecoration(
                labelText: 'Stok Porsi',
                prefixIcon: Icon(Icons.inventory_2),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.deskripsiC,
              maxLines: 3,
              validator: controller.validateDeskripsi,
              decoration: const InputDecoration(
                labelText: 'Deskripsi (maks. 100 karakter)',
                prefixIcon: Icon(Icons.notes),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => SwitchListTile(
                title: const Text('Tersedia'),
                subtitle: Text(
                  controller.tersediaForm.value
                      ? 'Menu dapat dipesan pelanggan'
                      : 'Menu sedang tidak tersedia',
                ),
                value: controller.tersediaForm.value,
                onChanged: (v) => controller.tersediaForm.value = v,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Theme.of(context).dividerColor),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: controller.save,
              icon: const Icon(Icons.save),
              label: Text(controller.isEdit ? 'Perbarui' : 'Simpan'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}