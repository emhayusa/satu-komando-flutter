class ReportType {
  int? id;
  String? uuid;
  String name;

  ReportType({
    this.id,
    this.uuid,
    required this.name,
  });

  factory ReportType.fromJson(Map<String, dynamic> json) => ReportType(
        id: json["id"],
        uuid: json["uuid"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "name": name,
      };
}
