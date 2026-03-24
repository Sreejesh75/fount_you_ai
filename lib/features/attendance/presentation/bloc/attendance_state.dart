import 'package:equatable/equatable.dart';
import '../../data/models/attendance_model.dart';
import '../../data/models/dashboard_summary_model.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceSuccess extends AttendanceState {
  final AttendanceModel record;
  const AttendanceSuccess(this.record);

  @override
  List<Object?> get props => [record];
}

class AttendanceSummaryLoaded extends AttendanceState {
  final DashboardSummaryModel summary;
  const AttendanceSummaryLoaded(this.summary);

  @override
  List<Object?> get props => [summary];
}

class AttendanceReportLoaded extends AttendanceState {
  final List<Map<String, dynamic>> report;
  const AttendanceReportLoaded(this.report);

  @override
  List<Object?> get props => [report];
}

class AttendanceError extends AttendanceState {
  final String message;
  const AttendanceError(this.message);

  @override
  List<Object?> get props => [message];
}
