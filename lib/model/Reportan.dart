import 'package:kjm_security/model/lokasi.dart';
import 'package:kjm_security/model/reportType.dart';
import 'package:kjm_security/model/reporter.dart';

class Reportan {
  int id;
  String uuid;
  String description;
  String? penanganan;
  DateTime createdAt;
  ReportType reportType;
  Lokasi lokasi;
  Reporter user;

  Reportan({
    required this.id,
    required this.uuid,
    required this.description,
    this.penanganan,
    required this.createdAt,
    required this.reportType,
    required this.lokasi,
    required this.user,
  });

  factory Reportan.fromJson(Map<String, dynamic> json) => Reportan(
        id: json["id"],
        uuid: json["uuid"],
        description: json["description"],
        penanganan: json["penanganan"],
        createdAt: DateTime.parse(json["createdAt"]),
        reportType: ReportType.fromJson(json["reportType"]),
        lokasi: Lokasi.fromJson(json["lokasi"]),
        user: Reporter.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "description": description,
        "penanganan": penanganan,
        "createdAt": createdAt.toIso8601String(),
        "reportType": reportType.toJson(),
        "lokasi": lokasi.toJson(),
        "user": user.toJson(),
      };
}
