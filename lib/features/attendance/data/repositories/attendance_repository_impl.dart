import '../../data/datasources/attendance_remote_data_source.dart';
import '../../data/models/attendance_model.dart';
import '../../domain/repositories/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remoteDataSource;

  AttendanceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AttendanceModel> markAttendance(String workerId) async {
    return await remoteDataSource.markAttendance(workerId);
  }

  @override
  Future<List<Map<String, dynamic>>> getAttendanceReport(String date) async {
    return await remoteDataSource.getAttendanceReport(date);
  }

  @override
  Future<Map<String, dynamic>> getAttendanceSummary() async {
    return await remoteDataSource.getDashboardSummary();
  }
}
