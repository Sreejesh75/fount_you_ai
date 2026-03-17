import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String phoneNumber;
  final String? role;

  const UserModel({
    required this.id,
    required this.phoneNumber,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'role': role,
    };
  }

  @override
  List<Object?> get props => [id, phoneNumber, role];
}
