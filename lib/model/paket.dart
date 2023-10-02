class Paketan {
  String recipient;
  String code;
  DateTime arrivedDatetime;
  String address;
  String hp;
  DateTime? takenDatetime;

  Paketan({
    required this.recipient,
    required this.code,
    required this.arrivedDatetime,
    required this.address,
    required this.hp,
    this.takenDatetime,
  });

  factory Paketan.fromJson(Map<String, dynamic> json) => Paketan(
        recipient: json["recipient"],
        code: json["code"],
        arrivedDatetime: DateTime.parse(json["arrived_datetime"]),
        address: json["address"],
        hp: json["hp"],
        takenDatetime: json["taken_datetime"] == null
            ? null
            : DateTime.parse(json["taken_datetime"]),
      );

  Map<String, dynamic> toJson() => {
        "recipient": recipient,
        "code": code,
        "arrived_datetime": arrivedDatetime.toIso8601String(),
        "address": address,
        "hp": hp,
        "taken_datetime": takenDatetime?.toIso8601String(),
      };
}
