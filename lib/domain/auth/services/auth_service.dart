abstract class AuthService {
  Future<String> sendOtp(String phone);
  Future<bool> verifyOtp(String verificationId, String otp);
}
