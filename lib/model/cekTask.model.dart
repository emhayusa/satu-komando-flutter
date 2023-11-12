import 'package:kjm_security/model/lokasi.dart';
import 'package:kjm_security/model/reporter.dart';
import 'package:kjm_security/model/warehouseType.dart';

class CekTaskModel {
  String uuid;
  String noSurat;
  String noPolisi;
  DateTime tanggal;
  DateTime waktuBox;
  DateTime? waktuKarung;
  DateTime? waktuKeluar;
  DateTime? waktuSelesai;
  String? description;
  int? jumlahKarung;
  int? jumlahCek;
  DateTime createdAt;
  WarehouseType warehouseType;
  Lokasi lokasi;
  Reporter user;

  CekTaskModel({
    required this.uuid,
    required this.noSurat,
    required this.noPolisi,
    required this.tanggal,
    required this.waktuBox,
    this.waktuKeluar,
    this.waktuKarung,
    this.waktuSelesai,
    this.description,
    this.jumlahKarung,
    this.jumlahCek,
    required this.createdAt,
    required this.warehouseType,
    required this.lokasi,
    required this.user,
  });

  factory CekTaskModel.fromJson(Map<String, dynamic> json) => CekTaskModel(
        uuid: json["uuid"],
        noSurat: json["noSurat"],
        noPolisi: json["noPolisi"],
        tanggal: DateTime.parse(json["tanggal"]),
        waktuBox: DateTime.parse(json["waktuBox"]),
        waktuKeluar: json["waktuKeluar"] == null
            ? null
            : DateTime.parse(json["waktuKeluar"]),
        waktuKarung: json["waktuKarung"] == null
            ? null
            : DateTime.parse(json["waktuKarung"]),
        waktuSelesai: json["waktuSelesai"] == null
            ? null
            : DateTime.parse(json["waktuSelesai"]),
        description: json["description"],
        jumlahKarung: json["jumlahKarung"],
        jumlahCek: json["jumlahCek"],
        createdAt: DateTime.parse(json["createdAt"]),
        warehouseType: WarehouseType.fromJson(json["warehouseType"]),
        lokasi: Lokasi.fromJson(json["lokasi"]),
        user: Reporter.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "noSurat": noSurat,
        "noPolisi": noPolisi,
        "tanggal":
            "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "waktuBox": waktuBox.toIso8601String(),
        "waktuKeluar": waktuKeluar?.toIso8601String(),
        "waktuKarung": waktuKarung?.toIso8601String(),
        "waktuSelesai": waktuSelesai?.toIso8601String(),
        "description": description,
        "jumlahKarung": jumlahKarung,
        "jumlahCek": jumlahCek,
        "createdAt": createdAt.toIso8601String(),
        "warehouseType": warehouseType.toJson(),
        "lokasi": lokasi.toJson(),
        "user": user.toJson(),
      };
}
