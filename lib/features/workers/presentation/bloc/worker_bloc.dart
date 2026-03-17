import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/worker_repository.dart';
import 'worker_event.dart';
import 'worker_state.dart';

class WorkerBloc extends Bloc<WorkerEvent, WorkerState> {
  final WorkerRepository repository;

  WorkerBloc({required this.repository}) : super(WorkerInitial()) {
    on<RegisterWorkerEvent>(_onRegisterWorker);
    on<FetchAllWorkersEvent>(_onFetchAllWorkers);
    on<UpdateWorkerEvent>(_onUpdateWorker);
    on<DeleteWorkerEvent>(_onDeleteWorker);
  }

  Future<void> _onRegisterWorker(
    RegisterWorkerEvent event,
    Emitter<WorkerState> emit,
  ) async {
    emit(WorkerLoading());
    try {
      final worker = await repository.registerWorker(
        name: event.name,
        jobRole: event.jobRole,
        place: event.place,
        contactNumber: event.contactNumber,
        dailyWage: event.dailyWage,
        photo: event.photo,
        faceData: event.faceData,
      );
      emit(WorkerRegisteredSuccess(worker));
    } catch (e) {
      emit(WorkerError(e.toString()));
    }
  }

  Future<void> _onFetchAllWorkers(
    FetchAllWorkersEvent event,
    Emitter<WorkerState> emit,
  ) async {
    emit(WorkerLoading());
    try {
      final workers = await repository.getAllWorkers();
      emit(WorkersLoadedSuccess(workers));
    } catch (e) {
      emit(WorkerError(e.toString()));
    }
  }

  Future<void> _onUpdateWorker(
    UpdateWorkerEvent event,
    Emitter<WorkerState> emit,
  ) async {
    emit(WorkerLoading());
    try {
      await repository.updateWorker(
        id: event.id,
        name: event.name,
        jobRole: event.jobRole,
        place: event.place,
        contactNumber: event.contactNumber,
        dailyWage: event.dailyWage,
        photo: event.photo,
      );
      emit(const WorkerActionSuccess('Worker updated successfully'));
      // Trigger a refresh
      add(FetchAllWorkersEvent());
    } catch (e) {
      emit(WorkerError(e.toString()));
    }
  }

  Future<void> _onDeleteWorker(
    DeleteWorkerEvent event,
    Emitter<WorkerState> emit,
  ) async {
    emit(WorkerLoading());
    try {
      await repository.deleteWorker(event.id);
      emit(const WorkerActionSuccess('Worker deleted successfully'));
      // Trigger a refresh
      add(FetchAllWorkersEvent());
    } catch (e) {
      emit(WorkerError(e.toString()));
    }
  }
}
