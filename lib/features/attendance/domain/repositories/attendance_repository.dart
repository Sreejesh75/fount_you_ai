import '../../data/models/attendance_model.dart';

abstract class AttendanceRepository {
  Future<AttendanceModel> markAttendance(String workerId);
  Future<List<Map<String, dynamic>>> getAttendanceReport(String date);
}
