/// Model yang merepresentasikan konfigurasi kolom dalam tabel data atau grid.
class ColumnsModel {
  /// Nama field dalam sumber data.
  String dbfieldName;

  /// Nama tampilan kolom. Defaultnya adalah [fieldName] jika tidak diberikan.
  String localFieldname;

  /// Tipe data dari field. Defaultnya adalah [dynamic] jika tidak diberikan.
  Type fieldType;

  /// Lebar kolom. Defaultnya adalah 100 jika tidak diberikan. \n
  double width;

  /// Lebar kolom. Defaultnya adalah 100 jika tidak diberikan. \n
  double minWidth;

  /// Label kolom, digunakan untuk tujuan tampilan. Defaultnya adalah versi terformat dari [name] atau [fieldName].
  String label;

  /// Flag yang menunjukkan apakah kolom terlihat. Defaultnya adalah true. \n
  bool visible;

  /// Flag yang menunjukkan apakah kolom harus meregang untuk mengisi ruang yang tersedia. Defaultnya adalah false. \n
  bool stretch;

  /// Flag yang menunjukkan apakah kolom dilindungi. Kolom yang dilindungi mungkin memiliki penanganan atau pembatasan khusus. Defaultnya adalah false.
  bool protected;

  /// Membuat [ColumnsModel] dengan properti yang diberikan.
  ///
  /// Parameter [fieldName] adalah wajib.
  /// Parameter [name], [label], [visible], [stretch], [fieldType], [width], dan [protected] adalah opsional.
  ColumnsModel(
    this.dbfieldName, {
    String? localFieldname,
    String? label,
    this.visible = true,
    this.stretch = false,
    this.fieldType = dynamic,
    this.minWidth = 30,
    this.width = 100,
    this.protected = false, //
  }) : localFieldname = localFieldname ?? dbfieldName,
       label = (label ?? localFieldname ?? dbfieldName).split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
}
