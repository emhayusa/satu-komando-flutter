import 'package:kjm_security/model/lokasi.dart';
import 'package:kjm_security/model/reportType.dart';
import 'package:kjm_security/model/reporter.dart';

class Reportan {
  String uuid;
  String description;
  DateTime createdAt;
  ReportType reportType;
  Lokasi lokasi;
  Reporter user;

  Reportan({
    required this.uuid,
    required this.description,
    required this.createdAt,
    required this.reportType,
    required this.lokasi,
    required this.user,
  });

  factory Reportan.fromJson(Map<String, dynamic> json) => Reportan(
        uuid: json["uuid"],
        description: json["description"],
        createdAt: DateTime.parse(json["createdAt"]),
        reportType: ReportType.fromJson(json["reportType"]),
        lokasi: Lokasi.fromJson(json["lokasi"]),
        user: Reporter.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "description": description,
        "createdAt": createdAt.toIso8601String(),
        "reportType": reportType.toJson(),
        "lokasi": lokasi.toJson(),
        "user": user.toJson(),
      };
}
