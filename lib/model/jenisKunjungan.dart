class JenisKunjungan {
  int id;
  String uuid;
  String name;

  JenisKunjungan({
    required this.id,
    required this.uuid,
    required this.name,
  });

  factory JenisKunjungan.fromJson(Map<String, dynamic> json) => JenisKunjungan(
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
