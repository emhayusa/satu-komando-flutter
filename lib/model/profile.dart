class Profile {
  String code;
  String nip;
  String fullName;
  String position;
  String hp;
  String address;
  String officeName;

  Profile({
    required this.code,
    required this.nip,
    required this.fullName,
    required this.position,
    required this.hp,
    required this.address,
    required this.officeName,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        code: json["code"],
        nip: json["nip"],
        fullName: json["full_name"],
        position: json["position"],
        hp: json["hp"],
        address: json["address"],
        officeName: json["office_name"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "nip": nip,
        "full_name": fullName,
        "position": position,
        "hp": hp,
        "address": address,
        "office_name": officeName,
      };
}
