import 'package:get_it/get_it.dart';
import 'core/network/dio_client.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/attendance/data/datasources/attendance_remote_data_source.dart';
import 'features/attendance/data/repositories/attendance_repository_impl.dart';
import 'features/attendance/domain/repositories/attendance_repository.dart';
import 'features/attendance/presentation/bloc/attendance_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/workers/data/datasources/worker_remote_data_source.dart';
import 'features/workers/data/repositories/worker_repository_impl.dart';
import 'features/workers/domain/repositories/worker_repository.dart';
import 'features/workers/presentation/bloc/worker_bloc.dart';

final sl = GetIt.instance;

void init() {
  // BLoC
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
  sl.registerFactory(() => WorkerBloc(repository: sl()));
  sl.registerFactory(() => AttendanceBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<WorkerRepository>(
    () => WorkerRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<WorkerRemoteDataSource>(
    () => WorkerRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<AttendanceRemoteDataSource>(
    () => AttendanceRemoteDataSourceImpl(dioClient: sl()),
  );

  // Core
  sl.registerLazySingleton(() => DioClient());
}
