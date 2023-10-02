/*
  code UUID NOT NULL,
  attendance_date DATE NOT NULL,
  attendance_status attendance_status_enum,
  leave_id INTEGER REFERENCES leaves(leave_id),
  presence_id INTEGER
  */

class Attendance {
  String code;
  DateTime attendanceDate;
  String attendanceStatus;
  int? leaveId;
  int? presenceId;

  Attendance({
    required this.code,
    required this.attendanceDate,
    required this.attendanceStatus,
    this.leaveId,
    this.presenceId,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        code: json["code"],
        attendanceDate: DateTime.parse(json["attendance_date"]),
        attendanceStatus: json["attendance_status"],
        leaveId: json["leave_id"] == null ? 0 : int.parse(json["leave_id"]),
        presenceId:
            json["presence_id"] == null ? 0 : int.parse(json["presence_id"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "attendance_date": attendanceDate.toIso8601String(),
        "attendance_status": attendanceStatus,
        "leave_id": leaveId,
        "presence_id": presenceId,
      };
}
