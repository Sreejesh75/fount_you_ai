import 'package:equatable/equatable.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object?> get props => [];
}

class MarkAttendanceEvent extends AttendanceEvent {
  final String workerId;
  const MarkAttendanceEvent(this.workerId);

  @override
  List<Object?> get props => [workerId];
}

class FetchAttendanceReportEvent extends AttendanceEvent {
  final String date;
  const FetchAttendanceReportEvent(this.date);

  @override
  List<Object?> get props => [date];
}
