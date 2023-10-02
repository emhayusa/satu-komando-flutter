class Presence {
  String code;
  DateTime arrivalDatetime;
  double arrivalLong;
  double arrivalLat;
  DateTime? leavingDatetime;
  double? leavingLong;
  double? leavingLat;

  Presence({
    required this.code,
    required this.arrivalDatetime,
    required this.arrivalLong,
    required this.arrivalLat,
    this.leavingDatetime,
    this.leavingLong,
    this.leavingLat,
  });

  factory Presence.fromJson(Map<String, dynamic> json) => Presence(
        code: json["code"],
        arrivalDatetime: DateTime.parse(json["arrival_datetime"]),
        arrivalLong: json["arrival_long"],
        arrivalLat: json["arrival_lat"],
        leavingDatetime: DateTime.parse(json["leaving_datetime"]),
        leavingLong: json["leaving_long"],
        leavingLat: json["leaving_lat"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "arrival_datetime": arrivalDatetime.toIso8601String(),
        "arrival_long": arrivalLong,
        "arrival_lat": arrivalLat,
        "leaving_datetime": leavingDatetime?.toIso8601String(),
        "leaving_long": leavingLong,
        "leaving_lat": leavingLat,
      };
}
