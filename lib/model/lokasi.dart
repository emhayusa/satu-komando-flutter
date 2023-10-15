class Lokasi {
  String uuid;
  String lokasiName;

  Lokasi({
    required this.uuid,
    required this.lokasiName,
  });

  factory Lokasi.fromJson(Map<String, dynamic> json) => Lokasi(
        uuid: json["uuid"],
        lokasiName: json["lokasiName"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "lokasiName": lokasiName,
      };
}
