class ApiEndpoints {
  // 🔴 CHANGE THIS TO YOUR REAL BASE URL
  static const String baseUrl =
      "https://e98c-2409-40c1-54-3641-2d94-7616-1f74-d6ac.ngrok-free.app/api/";

  // ---------------- AUTH ----------------
  // static const String login =
  //     "$baseUrl/login.php";
  //
  // static const String register =
  //     "$baseUrl/register.php";
  //
  // static const String verifyOtp =
  //     "$baseUrl/verify_otp.php";
  //
  // static const String sendOtp =
  //     "$baseUrl/send_otp.php";
  //
  // // ---------------- FORGOT PASSWORD (NEW) ----------------
  // static const String forgotPassword =
  //     "$baseUrl/forgot_password.php";
  //
  // static const String verifyResetOtp =
  //     "$baseUrl/verify_reset_otp.php";
  //
  // static const String resetPassword =
  //     "$baseUrl/reset_password.php";
  static const String login = "$baseUrl/login.php";

  // 🔥 REGISTER FLOW
  static const String sendOtp = "$baseUrl/send_otp.php";
  static const String verifyOtp = "$baseUrl/verify_otp.php";

  // 🔥 FORGOT PASSWORD FLOW
  static const String forgotPassword = "$baseUrl/forgot_password.php";
  static const String verifyResetOtp = "$baseUrl/verify_reset_otp.php";
  static const String resetPassword = "$baseUrl/reset_password.php";
}