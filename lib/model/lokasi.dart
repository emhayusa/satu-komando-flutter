class Lokasi {
  int? id;
  String? uuid;

  String lokasiName;

  Lokasi({
    this.id,
    this.uuid,
    required this.lokasiName,
  });

  factory Lokasi.fromJson(Map<String, dynamic> json) => Lokasi(
        id: json["id"],
        uuid: json["uuid"],
        lokasiName: json["lokasiName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "lokasiName": lokasiName,
      };
}
