import 'package:hive/hive.dart';
import 'menu_model.dart';

/// TypeAdapter manual untuk class Menu (Paket 2).
/// typeId unik (0 - 223), dan urutan read HARUS sama persis dengan write.
class MenuAdapter extends TypeAdapter<Menu> {
  @override
  final int typeId = 2;

  @override
  Menu read(BinaryReader reader) {
    return Menu(
      id: reader.readString(),
      nama: reader.readString(),
      kategori: reader.readString(),
      harga: reader.readDouble(),
      deskripsi: reader.readString(),
      stokPorsi: reader.readInt(),
      tersedia: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, Menu obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.nama);
    writer.writeString(obj.kategori);
    writer.writeDouble(obj.harga);
    writer.writeString(obj.deskripsi);
    writer.writeInt(obj.stokPorsi);
    writer.writeBool(obj.tersedia);
  }
}