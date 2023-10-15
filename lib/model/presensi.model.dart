import 'package:kjm_security/model/reporter.dart';

class Presensi {
  String uuid;
  DateTime tanggal;
  String longDatang;
  String latDatang;
  DateTime waktuDatang;
  dynamic longPulang;
  dynamic latPulang;
  DateTime? waktuPulang;
  DateTime createdAt;
  Reporter user;

  Presensi({
    required this.uuid,
    required this.tanggal,
    required this.longDatang,
    required this.latDatang,
    required this.waktuDatang,
    this.longPulang,
    this.latPulang,
    this.waktuPulang,
    required this.createdAt,
    required this.user,
  });

  factory Presensi.fromJson(Map<String, dynamic> json) => Presensi(
        uuid: json["uuid"],
        tanggal: DateTime.parse(json["tanggal"]),
        longDatang: json["longDatang"],
        latDatang: json["latDatang"],
        waktuDatang: DateTime.parse(json["waktuDatang"]),
        longPulang: json["longPulang"],
        latPulang: json["latPulang"],
        waktuPulang: json["waktuPulang"] == null
            ? null
            : DateTime.parse(json["waktuPulang"]),
        createdAt: DateTime.parse(json["createdAt"]),
        user: Reporter.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "tanggal":
            "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "longDatang": longDatang,
        "latDatang": latDatang,
        "waktuDatang": waktuDatang.toIso8601String(),
        "longPulang": longPulang,
        "latPulang": latPulang,
        "waktuPulang": waktuPulang?.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "user": user.toJson(),
      };
}
