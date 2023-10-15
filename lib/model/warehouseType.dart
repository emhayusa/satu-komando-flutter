class WarehouseType {
  String uuid;
  String name;

  WarehouseType({
    required this.uuid,
    required this.name,
  });

  factory WarehouseType.fromJson(Map<String, dynamic> json) => WarehouseType(
        uuid: json["uuid"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "name": name,
      };
}
