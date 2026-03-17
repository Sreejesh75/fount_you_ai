import '../../data/models/worker_model.dart';

import 'dart:io';

abstract class WorkerRepository {
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
