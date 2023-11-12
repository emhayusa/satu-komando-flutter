import 'package:kjm_security/model/jenisKunjungan.dart';
import 'package:kjm_security/model/jenisSatuan.dart';
import 'package:kjm_security/model/lokasi.dart';
import 'package:kjm_security/model/reporter.dart';

class KunjunganModel {
  int id;
  String uuid;
  String description;
  String hasil;
  DateTime tanggal;
  DateTime waktuDatang;
  DateTime createdAt;
  JenisSatuan jenisSatuan;
  JenisKunjungan jenisKunjungan;
  Lokasi lokasi;
  Reporter user;

  KunjunganModel({
    required this.id,
    required this.uuid,
    required this.description,
    required this.hasil,
    required this.tanggal,
    required this.waktuDatang,
    required this.createdAt,
    required this.jenisSatuan,
    required this.jenisKunjungan,
    required this.lokasi,
    required this.user,
  });

  factory KunjunganModel.fromJson(Map<String, dynamic> json) => KunjunganModel(
        id: json["id"],
        uuid: json["uuid"],
        description: json["description"],
        hasil: json["hasil"],
        tanggal: DateTime.parse(json["tanggal"]),
        waktuDatang: DateTime.parse(json["waktuDatang"]),
        createdAt: DateTime.parse(json["createdAt"]),
        jenisSatuan: JenisSatuan.fromJson(json["jenisSatuan"]),
        jenisKunjungan: JenisKunjungan.fromJson(json["jenisKunjungan"]),
        lokasi: Lokasi.fromJson(json["lokasi"]),
        user: Reporter.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "description": description,
        "hasil": hasil,
        "tanggal":
            "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "waktuDatang": waktuDatang.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "jenisSatuan": jenisSatuan.toJson(),
        "jenisKunjungan": jenisKunjungan.toJson(),
        "lokasi": lokasi.toJson(),
        "user": user.toJson(),
      };
}
