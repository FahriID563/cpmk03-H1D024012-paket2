/// Model data untuk Menu Kafe (Paket 2).
class Menu {
  final String id;
  final String nama;
  final String kategori;
  final double harga;
  final String deskripsi;
  final int stokPorsi;
  final bool tersedia;

  Menu({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.harga,
    required this.deskripsi,
    required this.stokPorsi,
    required this.tersedia,
  });

  Menu copyWith({
    String? id,
    String? nama,
    String? kategori,
    double? harga,
    String? deskripsi,
    int? stokPorsi,
    bool? tersedia,
  }) {
    return Menu(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      kategori: kategori ?? this.kategori,
      harga: harga ?? this.harga,
      deskripsi: deskripsi ?? this.deskripsi,
      stokPorsi: stokPorsi ?? this.stokPorsi,
      tersedia: tersedia ?? this.tersedia,
    );
  }

  @override
  String toString() {
    return 'Menu(id: $id, nama: $nama, kategori: $kategori, harga: $harga, deskripsi: $deskripsi, stokPorsi: $stokPorsi, tersedia: $tersedia)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Menu &&
        other.id == id &&
        other.nama == nama &&
        other.kategori == kategori &&
        other.harga == harga &&
        other.deskripsi == deskripsi &&
        other.stokPorsi == stokPorsi &&
        other.tersedia == tersedia;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nama.hashCode ^
        kategori.hashCode ^
        harga.hashCode ^
        deskripsi.hashCode ^
        stokPorsi.hashCode ^
        tersedia.hashCode;
  }
}
