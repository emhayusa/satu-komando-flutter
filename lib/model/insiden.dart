class Insiden {
  String code;
  DateTime incidentTime;
  String category;
  String situation;

  Insiden({
    required this.code,
    required this.incidentTime,
    required this.category,
    required this.situation,
  });

  factory Insiden.fromJson(Map<String, dynamic> json) => Insiden(
        code: json["code"],
        incidentTime: DateTime.parse(json["incident_time"]),
        category: json["category"],
        situation: json["situation"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "incident_time": incidentTime.toIso8601String(),
        "category": category,
        "situation": situation,
      };
}
