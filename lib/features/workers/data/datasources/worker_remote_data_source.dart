import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/worker_model.dart';
import 'dart:io';

abstract class WorkerRemoteDataSource {
  Future<WorkerModel> registerWorker({
    required String name,
    required String jobRole,
    required String place,
    required String contactNumber,
    required double dailyWage,
    required File photo,
    String? faceData,
  });
  Future<List<WorkerModel>> getAllWorkers();
  Future<WorkerModel> updateWorker({
    required String id,
    String? name,
    String? jobRole,
    String? place,
    String? contactNumber,
    double? dailyWage,
    File? photo,
  });
  Future<void> deleteWorker(String id);
}

class WorkerRemoteDataSourceImpl implements WorkerRemoteDataSource {
  final DioClient dioClient;

  WorkerRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<WorkerModel> registerWorker({
    required String name,
    required String jobRole,
    required String place,
    required String contactNumber,
    required double dailyWage,
    required File photo,
    String? faceData,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'jobRole': jobRole,
        'place': place,
        'contactNumber': contactNumber,
        'dailyWage': dailyWage,
        if (faceData != null) 'faceData': faceData,
        'photo': await MultipartFile.fromFile(
          photo.path,
          filename: 'worker_photo.jpg',
        ),
      });

      final response = await dioClient.dio.post(
        ApiConstants.workers,
        data: formData,
      );

      if (response.statusCode == 201) {
        return WorkerModel.fromJson(response.data['worker']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to register worker',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<WorkerModel>> getAllWorkers() async {
    try {
      final response = await dioClient.dio.get(ApiConstants.workers);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => WorkerModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to fetch workers',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<WorkerModel> updateWorker({
    required String id,
    String? name,
    String? jobRole,
    String? place,
    String? contactNumber,
    double? dailyWage,
    File? photo,
  }) async {
    try {
      final formDataMap = <String, dynamic>{};
      if (name != null) formDataMap['name'] = name;
      if (jobRole != null) formDataMap['jobRole'] = jobRole;
      if (place != null) formDataMap['place'] = place;
      if (contactNumber != null) formDataMap['contactNumber'] = contactNumber;
      if (dailyWage != null) formDataMap['dailyWage'] = dailyWage;
      
      if (photo != null) {
        formDataMap['photo'] = await MultipartFile.fromFile(
          photo.path,
          filename: 'updated_worker_photo.jpg',
        );
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await dioClient.dio.put(
        '${ApiConstants.workers}/$id',
        data: formData,
      );

      if (response.statusCode == 200) {
        return WorkerModel.fromJson(response.data['worker']);
      } else {
        throw response.data?['message'] ?? 'Failed to update worker';
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteWorker(String id) async {
    try {
      final response = await dioClient.dio.delete('${ApiConstants.workers}/$id');
      if (response.statusCode != 200) {
        throw response.data?['message'] ?? 'Failed to delete worker';
      }
    } catch (e) {
      rethrow;
    }
  }
}
