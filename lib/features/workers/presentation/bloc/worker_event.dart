import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class WorkerEvent extends Equatable {
  const WorkerEvent();

  @override
  List<Object?> get props => [];
}

class RegisterWorkerEvent extends WorkerEvent {
  final String name;
  final String jobRole;
  final String place;
  final String contactNumber;
  final double dailyWage;
  final File photo;
  final String? faceData;

  const RegisterWorkerEvent({
    required this.name,
    required this.jobRole,
    required this.place,
    required this.contactNumber,
    required this.dailyWage,
    required this.photo,
    this.faceData,
  });

  @override
  List<Object?> get props => [name, jobRole, place, contactNumber, dailyWage, photo, faceData];
}

class FetchAllWorkersEvent extends WorkerEvent {}

class UpdateWorkerEvent extends WorkerEvent {
  final String id;
  final String? name;
  final String? jobRole;
  final String? place;
  final String? contactNumber;
  final double? dailyWage;
  final File? photo;

  const UpdateWorkerEvent({
    required this.id,
    this.name,
    this.jobRole,
    this.place,
    this.contactNumber,
    this.dailyWage,
    this.photo,
  });

  @override
  List<Object?> get props => [id, name, jobRole, place, contactNumber, dailyWage, photo];
}

class DeleteWorkerEvent extends WorkerEvent {
  final String id;
  const DeleteWorkerEvent(this.id);

  @override
  List<Object?> get props => [id];
}
