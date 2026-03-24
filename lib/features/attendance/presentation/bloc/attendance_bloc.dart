import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../../data/models/dashboard_summary_model.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepository repository;

  AttendanceBloc({required this.repository}) : super(AttendanceInitial()) {
    on<MarkAttendanceEvent>(_onMarkAttendance);
    on<FetchAttendanceReportEvent>(_onFetchAttendanceReport);
    on<FetchDashboardSummaryEvent>(_onFetchDashboardSummary);
  }

  Future<void> _onFetchDashboardSummary(
    FetchDashboardSummaryEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());
    try {
      final summaryJson = await repository.getAttendanceSummary();
      final summary = DashboardSummaryModel.fromJson(summaryJson);
      emit(AttendanceSummaryLoaded(summary));
    } catch (e) {
      emit(AttendanceError(e.toString()));
    }
  }

  Future<void> _onMarkAttendance(
    MarkAttendanceEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());
    try {
      final record = await repository.markAttendance(event.workerId);
      emit(AttendanceSuccess(record));
    } catch (e) {
      emit(AttendanceError(e.toString()));
    }
  }

  Future<void> _onFetchAttendanceReport(
    FetchAttendanceReportEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());
    try {
      final report = await repository.getAttendanceReport(event.date);
      emit(AttendanceReportLoaded(report));
    } catch (e) {
      emit(AttendanceError(e.toString()));
    }
  }
}
