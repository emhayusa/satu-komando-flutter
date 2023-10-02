/*
check_point_name VARCHAR(100) NOT NULL,
  code UUID NOT NULL DEFAULT uuid_generate_v4() UNIQUE,
  latitude DECIMAL(9, 6) NOT NULL,
  longitude DECIMAL(9, 6) NOT NULL
*/
class CheckPoint {
  String code;
  String checkPointName;
  double? latitude;
  double? longitude;

  CheckPoint({
    required this.code,
    required this.checkPointName,
    required this.latitude,
    required this.longitude,
  });

  factory CheckPoint.fromJson(Map<String, dynamic> json) => CheckPoint(
        code: json["code"],
        checkPointName: json["check_point_name"],
        latitude: double.parse(json["latitude"]),
        longitude: double.parse(json["longitude"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "check_point_name": checkPointName,
        "longitude": longitude,
        "latitude": latitude,
      };
}
