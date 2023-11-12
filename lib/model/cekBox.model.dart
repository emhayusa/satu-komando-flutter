import 'package:kjm_security/model/lokasi.dart';
import 'package:kjm_security/model/reporter.dart';
import 'package:kjm_security/model/warehouseType.dart';

class CekBoxModel {
  String uuid;
  String noSurat;
  String noPolisi;
  String namaDriver;
  DateTime tanggal;
  DateTime waktuDatang;
  DateTime? waktuKabin;
  DateTime? waktuKeluar;
  DateTime? waktuBox;
  DateTime? waktuPaket;
  String? description;
  DateTime createdAt;
  WarehouseType warehouseType;
  Lokasi lokasi;
  Reporter user;

  CekBoxModel({
    required this.uuid,
    required this.noSurat,
    required this.noPolisi,
    required this.namaDriver,
    required this.tanggal,
    required this.waktuDatang,
    this.waktuKabin,
    this.waktuKeluar,
    this.waktuBox,
    this.waktuPaket,
    this.description,
    required this.createdAt,
    required this.warehouseType,
    required this.lokasi,
    required this.user,
  });

  factory CekBoxModel.fromJson(Map<String, dynamic> json) => CekBoxModel(
        uuid: json["uuid"],
        noSurat: json["noSurat"],
        noPolisi: json["noPolisi"],
        namaDriver: json["namaDriver"],
        tanggal: DateTime.parse(json["tanggal"]),
        waktuDatang: DateTime.parse(json["waktuDatang"]),
        waktuKabin: json["waktuKabin"] == null
            ? null
            : DateTime.parse(json["waktuKabin"]),
        waktuKeluar: json["waktuKeluar"] == null
            ? null
            : DateTime.parse(json["waktuKeluar"]),
        waktuBox:
            json["waktuBox"] == null ? null : DateTime.parse(json["waktuBox"]),
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
        "noSurat": noSurat,
        "noPolisi": noPolisi,
        "namaDriver": namaDriver,
        "tanggal":
            "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "waktuDatang": waktuDatang.toIso8601String(),
        "waktuKabin": waktuKabin?.toIso8601String(),
        "waktuKeluar": waktuKeluar?.toIso8601String(),
        "waktuBox": waktuBox?.toIso8601String(),
        "waktuPaket": waktuPaket?.toIso8601String(),
        "description": description,
        "createdAt": createdAt.toIso8601String(),
        "warehouseType": warehouseType.toJson(),
        "lokasi": lokasi.toJson(),
        "user": user.toJson(),
      };
}
