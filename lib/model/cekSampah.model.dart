import 'package:kjm_security/model/lokasi.dart';
import 'package:kjm_security/model/reporter.dart';
import 'package:kjm_security/model/warehouseType.dart';

class CekSampahModel {
  String uuid;
  DateTime tanggal;
  DateTime waktuBody;
  DateTime? waktuKeluar;
  DateTime? waktuKarung;
  DateTime? waktuPaket;
  String? description;
  DateTime createdAt;
  WarehouseType warehouseType;
  Lokasi lokasi;
  Reporter user;

  CekSampahModel({
    required this.uuid,
    required this.tanggal,
    required this.waktuBody,
    this.waktuKeluar,
    this.waktuKarung,
    this.waktuPaket,
    this.description,
    required this.createdAt,
    required this.warehouseType,
    required this.lokasi,
    required this.user,
  });

  factory CekSampahModel.fromJson(Map<String, dynamic> json) => CekSampahModel(
        uuid: json["uuid"],
        tanggal: DateTime.parse(json["tanggal"]),
        waktuBody: DateTime.parse(json["waktuBody"]),
        waktuKeluar: json["waktuKeluar"] == null
            ? null
            : DateTime.parse(json["waktuKeluar"]),
        waktuKarung: json["waktuKarung"] == null
            ? null
            : DateTime.parse(json["waktuKarung"]),
        waktuPaket: json["waktuPaket"] == null
            ? null
            : DateTime.parse(json["waktuPaket"]),
        description: json["description"],
        createdAt: DateTime.parse(json["createdAt"]),
        warehouseType: WarehouseType.fromJson(json["warehouseType"]),
        lokasi: Lokasi.fromJson(json["lokasi"]),
        user: Reporter.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "tanggal":
            "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "waktuBody": waktuBody.toIso8601String(),
        "waktuKeluar": waktuKeluar?.toIso8601String(),
        "waktuKarung": waktuKarung?.toIso8601String(),
        "waktuPaket": waktuPaket?.toIso8601String(),
        "description": description,
        "createdAt": createdAt.toIso8601String(),
        "warehouseType": warehouseType.toJson(),
        "lokasi": lokasi.toJson(),
        "user": user.toJson(),
      };
}
