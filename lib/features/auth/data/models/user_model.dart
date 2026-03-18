import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? role;

  const UserModel({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      name: json['name'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'name': name,
      'role': role,
    };
  }

  @override
  List<Object?> get props => [id, phoneNumber, name, role];
}
