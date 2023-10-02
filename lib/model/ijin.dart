class Ijinan {
  String code;
  DateTime leaveStartDate;
  DateTime leaveEndDate;
  DateTime requestDate;
  String notes;
  String? approvalStatus;
  DateTime? approvalDate;

  Ijinan({
    required this.code,
    required this.leaveStartDate,
    required this.leaveEndDate,
    required this.requestDate,
    required this.notes,
    this.approvalStatus,
    this.approvalDate,
  });

  factory Ijinan.fromJson(Map<String, dynamic> json) => Ijinan(
        code: json["code"],
        leaveStartDate: DateTime.parse(json["leave_start_date"]),
        leaveEndDate: DateTime.parse(json["leave_end_date"]),
        requestDate: DateTime.parse(json["request_date"]),
        notes: json["notes"],
        approvalStatus: json["approval_status"],
        approvalDate: json["approval_date"] == null
            ? null
            : DateTime.parse(json["approval_date"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "permission_date": leaveStartDate.toIso8601String(),
        "created_at": leaveEndDate.toIso8601String(),
        "request_date": requestDate.toIso8601String(),
        "notes": notes,
        "approval_status": approvalStatus,
        "approval_date": approvalDate,
      };
}
