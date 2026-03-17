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
    // Handle cases where workerId is an object or just a string
    String? wName = json['workerName'];
    String wId = '';
    
    if (json['workerId'] is Map) {
      wId = json['workerId']['_id'] ?? '';
      wName ??= json['workerId']['name'];
    } else {
      wId = json['workerId']?.toString() ?? '';
    }

    return AttendanceModel(
      id: json['_id'] ?? '',
      workerId: wId,
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      workerName: wName,
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
