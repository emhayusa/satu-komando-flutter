class JenisPresensi {
  int? id;
  String? uuid;
  String name;

  JenisPresensi({
    this.id,
    this.uuid,
    required this.name,
  });

  factory JenisPresensi.fromJson(Map<String, dynamic> json) => JenisPresensi(
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
