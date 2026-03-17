import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/attendance_model.dart';

abstract class AttendanceRemoteDataSource {
  Future<AttendanceModel> markAttendance(String workerId);
  Future<List<Map<String, dynamic>>> getAttendanceReport(String date);
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final DioClient dioClient;

  AttendanceRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<AttendanceModel> markAttendance(String workerId) async {
    try {
      final response = await dioClient.dio.post(
        ApiConstants.markAttendance,
        data: {'workerId': workerId},
      );

      if (response.statusCode == 201) {
        final recordJson = Map<String, dynamic>.from(response.data['record']);
        // Add workerName from top level to the record map for parsing
        recordJson['workerName'] = response.data['workerName'];
        return AttendanceModel.fromJson(recordJson);
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to mark attendance';
        throw errorMessage;
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? e.message ?? 'Network error occurred';
      throw errorMessage;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAttendanceReport(String date) async {
    try {
      final response = await dioClient.dio.get(
        ApiConstants.getReport,
        queryParameters: {'date': date},
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['details']);
      } else {
        throw response.data?['message'] ?? 'Failed to fetch report';
      }
    } catch (e) {
      rethrow;
    }
  }
}
