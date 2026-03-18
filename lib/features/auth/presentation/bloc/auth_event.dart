import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class RequestOtpEvent extends AuthEvent {
  final String phoneNumber;

  const RequestOtpEvent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class VerifyOtpAndSetPasswordEvent extends AuthEvent {
  final String phoneNumber;
  final String otp;
  final String password;

  const VerifyOtpAndSetPasswordEvent({
    required this.phoneNumber,
    required this.otp,
    required this.password,
  });

  @override
  List<Object?> get props => [phoneNumber, otp, password];
}

class LoginEvent extends AuthEvent {
  final String phoneNumber;
  final String password;

  const LoginEvent({required this.phoneNumber, required this.password});

  @override
  List<Object?> get props => [phoneNumber, password];
}

class CheckAuthStatusEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

class AuthUserUpdatedEvent extends AuthEvent {
  final UserModel user;

  const AuthUserUpdatedEvent(this.user);

  @override
  List<Object?> get props => [user];
}
