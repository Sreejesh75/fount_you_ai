import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> requestOtp(String phoneNumber);
  Future<UserModel> verifyAndSetPassword(String phoneNumber, String otp, String password);
  Future<UserModel> login(String phoneNumber, String password);
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile({String? name, String? role});
  Future<void> deleteAccount();
  Future<void> logout();
  Future<bool> isLoggedIn();
}
