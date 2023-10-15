class Reporter {
  String uuid;
  String username;

  Reporter({
    required this.uuid,
    required this.username,
  });

  factory Reporter.fromJson(Map<String, dynamic> json) => Reporter(
        uuid: json["uuid"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "username": username,
      };
}
