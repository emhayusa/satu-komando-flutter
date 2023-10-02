class Tamu {
  String guestName;
  String code;
  DateTime visitDatetime;
  String comeTo;
  String purpose;
  String companyName;
  DateTime? departureDatetime;

  Tamu({
    required this.guestName,
    required this.code,
    required this.visitDatetime,
    required this.comeTo,
    required this.purpose,
    required this.companyName,
    this.departureDatetime,
  });

  factory Tamu.fromJson(Map<String, dynamic> json) => Tamu(
        guestName: json["guest_name"],
        code: json["code"],
        visitDatetime: DateTime.parse(json["visit_datetime"]),
        comeTo: json["come_to"],
        purpose: json["purpose"],
        companyName: json["company_name"],
        departureDatetime: json["departure_datetime"] == null
            ? null
            : DateTime.parse(json["departure_datetime"]),
      );

  Map<String, dynamic> toJson() => {
        "guest_name": guestName,
        "code": code,
        "visit_datetime": visitDatetime.toIso8601String(),
        "come_to": comeTo,
        "purpose": purpose,
        "company_name": companyName,
        "departure_datetime": departureDatetime?.toIso8601String(),
      };
}
