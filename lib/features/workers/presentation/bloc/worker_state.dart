import 'package:equatable/equatable.dart';
import '../../data/models/worker_model.dart';

abstract class WorkerState extends Equatable {
  const WorkerState();

  @override
  List<Object?> get props => [];
}

class WorkerInitial extends WorkerState {}

class WorkerLoading extends WorkerState {}

class WorkerRegisteredSuccess extends WorkerState {
  final WorkerModel worker;
  const WorkerRegisteredSuccess(this.worker);

  @override
  List<Object?> get props => [worker];
}

class WorkerActionSuccess extends WorkerState {
  final String message;
  const WorkerActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class WorkersLoadedSuccess extends WorkerState {
  final List<WorkerModel> workers;
  const WorkersLoadedSuccess(this.workers);

  @override
  List<Object?> get props => [workers];
}

class WorkerError extends WorkerState {
  final String message;
  const WorkerError(this.message);

  @override
  List<Object?> get props => [message];
}
