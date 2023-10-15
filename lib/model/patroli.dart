import 'package:kjm_security/model/lokasi.dart';
import 'package:kjm_security/model/reporter.dart';

class Patrolian {
  String uuid;
  String description;
  DateTime createdAt;
  Lokasi lokasi;
  Reporter user;

  Patrolian({
    required this.uuid,
    required this.description,
    required this.createdAt,
    required this.lokasi,
    required this.user,
  });

  factory Patrolian.fromJson(Map<String, dynamic> json) => Patrolian(
        uuid: json["uuid"],
        description: json["description"],
        createdAt: DateTime.parse(json["createdAt"]),
        lokasi: Lokasi.fromJson(json["lokasi"]),
        user: Reporter.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "description": description,
        "createdAt": createdAt.toIso8601String(),
        "lokasi": lokasi.toJson(),
        "user": user.toJson(),
      };
}
