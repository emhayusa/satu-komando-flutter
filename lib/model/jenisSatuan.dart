class JenisSatuan {
  int id;
  String uuid;
  String name;

  JenisSatuan({
    required this.id,
    required this.uuid,
    required this.name,
  });

  factory JenisSatuan.fromJson(Map<String, dynamic> json) => JenisSatuan(
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
