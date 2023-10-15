class ReportType {
  String uuid;
  String name;

  ReportType({
    required this.uuid,
    required this.name,
  });

  factory ReportType.fromJson(Map<String, dynamic> json) => ReportType(
        uuid: json["uuid"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "name": name,
      };
}
