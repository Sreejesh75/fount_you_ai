class ApiConstants {
  
  static const String baseUrl =
  //  'http://192.168.100.172:5000';
  'https://ai-attendence-backend.vercel.app';
  // Auth Endpoints
  static const String requestOtp = '/api/auth/request-otp';
  static const String verifyAndSetPassword = '/api/auth/verify-and-set-password';
  static const String login = '/api/auth/login';

  // Attendance Endpoints
  static const String markAttendance = '/api/attendance';
  static const String getReport = '/api/attendance/report';

  // Worker Endpoints
  static const String workers = '/api/workers';
}
