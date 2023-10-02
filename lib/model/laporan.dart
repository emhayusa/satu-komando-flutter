class Laporan {
  String code;
  DateTime permissionDate;
  DateTime createdAt;
  String? notes;
  String? status;
  String? updatedBy;

  Laporan({
    required this.code,
    required this.permissionDate,
    required this.createdAt,
    this.notes,
    this.status,
    this.updatedBy,
  });

  factory Laporan.fromJson(Map<String, dynamic> json) => Laporan(
        code: json["code"],
        permissionDate: DateTime.parse(json["permission_date"]),
        createdAt: DateTime.parse(json["created_at"]),
        notes: json["notes"],
        status: json["status"],
        updatedBy: json["updated_by"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "permission_date": permissionDate.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "notes": notes,
        "status": status,
        "updated_by": updatedBy,
      };
}
