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

      if (response.statusCode == 201 || response.statusCode == 200) {
        final dynamic data = response.data;
        
        if (data is Map) {
          final mapData = Map<String, dynamic>.from(data);
          if (mapData.containsKey('record')) {
            final recordJson = Map<String, dynamic>.from(mapData['record']);
            recordJson['workerName'] ??= mapData['workerName'];
            return AttendanceModel.fromJson(recordJson);
          }
          return AttendanceModel.fromJson(mapData);
        } else if (data is List && data.isNotEmpty) {
          // If server returns a list, use the first item
          return AttendanceModel.fromJson(Map<String, dynamic>.from(data.first));
        } else {
          throw 'Server returned an invalid format for attendance record';
        }
      } else {
        final errorMessage = response.data is Map ? (response.data?['message'] ?? 'Failed to mark attendance') : 'Server error: ${response.statusCode}';
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
        final dynamic data = response.data;
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        } else if (data is Map && data.containsKey('details')) {
          return List<Map<String, dynamic>>.from(data['details']);
        }
        return [];
      } else {
        throw response.data is Map ? (response.data?['message'] ?? 'Failed to fetch report') : 'Server error';
      }
    } catch (e) {
      rethrow;
    }
  }
}
