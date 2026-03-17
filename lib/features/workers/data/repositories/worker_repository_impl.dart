import 'dart:io';
import '../../data/datasources/worker_remote_data_source.dart';
import '../../data/models/worker_model.dart';
import '../../domain/repositories/worker_repository.dart';

class WorkerRepositoryImpl implements WorkerRepository {
  final WorkerRemoteDataSource remoteDataSource;

  WorkerRepositoryImpl({required this.remoteDataSource});

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
    return await remoteDataSource.registerWorker(
      name: name,
      jobRole: jobRole,
      place: place,
      contactNumber: contactNumber,
      dailyWage: dailyWage,
      photo: photo,
      faceData: faceData,
    );
  }

  @override
  Future<List<WorkerModel>> getAllWorkers() async {
    return await remoteDataSource.getAllWorkers();
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
    return await remoteDataSource.updateWorker(
      id: id,
      name: name,
      jobRole: jobRole,
      place: place,
      contactNumber: contactNumber,
      dailyWage: dailyWage,
      photo: photo,
    );
  }

  @override
  Future<void> deleteWorker(String id) async {
    return await remoteDataSource.deleteWorker(id);
  }
}
