class AttendanceModel {
  final String id;
  final String workerId;
  final String date;
  final String time;
  final String? workerName;

  AttendanceModel({
    required this.id,
    required this.workerId,
    required this.date,
    required this.time,
    this.workerName,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['_id'] ?? '',
      workerId: json['workerId']?['_id'] ?? json['workerId'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      workerName: json['workerName'] ?? json['workerId']?['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workerId': workerId,
      'date': date,
      'time': time,
    };
  }
}
