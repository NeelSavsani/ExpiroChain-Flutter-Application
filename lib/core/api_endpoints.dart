class ApiEndpoints {
  // For Android Emulator use:
  static const String baseUrl = "https://07bc6e014792.ngrok-free.app/api";

  // For ngrok (replace later):
  // static const String baseUrl = "https://xxxx.ngrok-free.app/api";

  static const String login = "$baseUrl/login.php";
  static const String register = "$baseUrl/register.php";
  static const String sendOtp = "$baseUrl/send_otp.php";
  static const String verifyOtp = "$baseUrl/verify_otp.php";
}
