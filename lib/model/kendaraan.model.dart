import 'package:kjm_security/model/lokasi.dart';
import 'package:kjm_security/model/reporter.dart';
import 'package:kjm_security/model/warehouseType.dart';

class Kendaraan {
  String uuid;
  DateTime tanggal;
  DateTime waktuDatang;
  String? noSealIn;
  String? noSealOut;
  String noSurat;
  String noPolisi;
  int totalTo;
  int totalParcel;
  DateTime? waktuKeluar;
  DateTime? waktuSealOut;
  DateTime? waktuSealIn;
  DateTime? waktuBongkar;
  DateTime? waktuSelesaiBongkar;
  String description;
  DateTime createdAt;
  WarehouseType warehouseType;
  Lokasi lokasi;
  Reporter user;

  Kendaraan({
    required this.uuid,
    required this.tanggal,
    required this.waktuDatang,
    this.noSealIn,
    this.noSealOut,
    required this.noSurat,
    required this.noPolisi,
    required this.totalTo,
    required this.totalParcel,
    this.waktuKeluar,
    this.waktuSealOut,
    this.waktuSealIn,
    this.waktuBongkar,
    this.waktuSelesaiBongkar,
    required this.description,
    required this.createdAt,
    required this.warehouseType,
    required this.lokasi,
    required this.user,
  });

  factory Kendaraan.fromJson(Map<String, dynamic> json) => Kendaraan(
        uuid: json["uuid"],
        tanggal: DateTime.parse(json["tanggal"]),
        waktuDatang: DateTime.parse(json["waktuDatang"]),
        noSealIn: json["noSealIn"],
        noSealOut: json["noSealOut"],
        noSurat: json["noSurat"],
        noPolisi: json["noPolisi"],
        totalTo: json["totalTO"],
        totalParcel: json["totalParcel"],
        waktuKeluar: json["waktuKeluar"] == null
            ? null
            : DateTime.parse(json["waktuKeluar"]),
        waktuSealOut: json["waktuSealOut"] == null
            ? null
            : DateTime.parse(json["waktuSealOut"]),
        waktuSealIn: json["waktuSealIn"] == null
            ? null
            : DateTime.parse(json["waktuSealIn"]),
        waktuBongkar: json["waktuBongkar"] == null
            ? null
            : DateTime.parse(json["waktuBongkar"]),
        waktuSelesaiBongkar: json["waktuSelesaiBongkar"] == null
            ? null
            : DateTime.parse(json["waktuSelesaiBongkar"]),
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
        "waktuDatang": waktuDatang.toIso8601String(),
        "noSealIn": noSealIn,
        "noSealOut": noSealOut,
        "noSurat": noSurat,
        "noPolisi": noPolisi,
        "totalTO": totalTo,
        "totalParcel": totalParcel,
        "waktuKeluar": waktuKeluar?.toIso8601String(),
        "waktuSealOut": waktuSealOut?.toIso8601String(),
        "waktuSealIn": waktuSealIn?.toIso8601String(),
        "waktuBongkar": waktuBongkar?.toIso8601String(),
        "waktuSelesaiBongkar": waktuSelesaiBongkar?.toIso8601String(),
        "description": description,
        "createdAt": createdAt.toIso8601String(),
        "warehouseType": warehouseType.toJson(),
        "lokasi": lokasi.toJson(),
        "user": user.toJson(),
      };
}
