import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRemoteDataSource {
  Future<String> requestOtp(String phoneNumber);
  Future<UserModel> verifyAndSetPassword(String phoneNumber, String otp, String password);
  Future<UserModel> login(String phoneNumber, String password);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<String> requestOtp(String phoneNumber) async {
    try {
      final response = await dioClient.dio.post(
        ApiConstants.requestOtp,
        data: {'phoneNumber': phoneNumber},
      );
      // Backend returns {"message": "OTP sent successfully", "otpForTesting": "..."}
      return response.data['message'] ?? 'OTP Requested';
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Failed to request OTP');
    }
  }

  @override
  Future<UserModel> verifyAndSetPassword(String phoneNumber, String otp, String password) async {
    try {
      final response = await dioClient.dio.post(
        ApiConstants.verifyAndSetPassword,
        data: {
          'phoneNumber': phoneNumber,
          'otp': otp,
          'password': password,
        },
      );
      
      final token = response.data['token'];
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
      }
      
      return UserModel.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Failed to verify OTP and set password');
    }
  }

  @override
  Future<UserModel> login(String phoneNumber, String password) async {
    try {
      final response = await dioClient.dio.post(
        ApiConstants.login,
        data: {
          'phoneNumber': phoneNumber,
          'password': password,
        },
      );
      
      final token = response.data['token'];
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
      }
      
      return UserModel.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Failed to login');
    }
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
