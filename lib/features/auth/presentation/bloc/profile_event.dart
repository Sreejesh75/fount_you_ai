import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String? name;
  final String? role;

  const UpdateProfileEvent({this.name, this.role});

  @override
  List<Object?> get props => [name, role];
}

class DeleteAccountEvent extends ProfileEvent {}
