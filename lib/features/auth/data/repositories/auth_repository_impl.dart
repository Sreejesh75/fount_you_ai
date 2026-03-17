import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> requestOtp(String phoneNumber) {
    return remoteDataSource.requestOtp(phoneNumber);
  }

  @override
  Future<UserModel> verifyAndSetPassword(String phoneNumber, String otp, String password) {
    return remoteDataSource.verifyAndSetPassword(phoneNumber, otp, password);
  }

  @override
  Future<UserModel> login(String phoneNumber, String password) {
    return remoteDataSource.login(phoneNumber, password);
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }

  @override
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }
}
