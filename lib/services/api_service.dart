import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'api_endpoints.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiService {
  // 🔥 CHANGE THIS TO YOUR REAL DOMAIN
  static const String baseUrl =
      "https://e98c-2409-40c1-54-3641-2d94-7616-1f74-d6ac.ngrok-free.app/api/";

  // ================= LOGIN =================
  static Future<Map<String, dynamic>> login(
      String email, String password) async {

    final response = await http.post(
      Uri.parse("$baseUrl/login.php"),
      body: {
        "username": email,
        "user_pass": password,
      },
    );

    return jsonDecode(response.body);
  }

  // ================= REGISTER SEND OTP =================
  static Future<Map<String, dynamic>> sendOtpWithFiles({
    required Map<String, String> fields,
    required Map<String, dynamic> files,
  }) async {

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/send_otp.php"),
    );

    request.fields.addAll(fields);

    files.forEach((key, file) async {
      if (file != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            key,
            file.path,
          ),
        );
      }
    });

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return jsonDecode(response.body);
  }

  // ================= VERIFY OTP =================
  static Future<Map<String, dynamic>> verifyOtp(
      String otp) async {

    final response = await http.post(
      Uri.parse("$baseUrl/verify_otp.php"),
      body: {"otp": otp},
    );

    return jsonDecode(response.body);
  }

  // ================= SEND RESET OTP =================
  static Future<bool> sendResetOtp(String identity) async {
    final response = await http.post(
      Uri.parse("$baseUrl/send_reset_otp.php"),
      body: {"user_identity": identity},
    );

    final data = jsonDecode(response.body);
    return data["status"] == "success";
  }

  // ================= VERIFY RESET OTP =================
  static Future<bool> verifyResetOtp(String otp) async {
    final response = await http.post(
      Uri.parse("$baseUrl/verify_reset_otp.php"),
      body: {"otp": otp},
    );

    final data = jsonDecode(response.body);
    return data["status"] == "success";
  }

  // ================= RESET PASSWORD =================
  static Future<bool> resetPassword(String newPassword) async {
    final response = await http.post(
      Uri.parse("$baseUrl/reset_password.php"),
      body: {
        "new_password": newPassword,
        "confirm_password": newPassword,
      },
    );

    final data = jsonDecode(response.body);
    return data["status"] == "success";
  }

  // ====================================================
  // 🔥🔥🔥 ACCOUNT DETAILS API (NEW)
  // ====================================================
  static Future<Map<String, dynamic>> getAccountDetails(
      String email) async {

    final response = await http.post(
      Uri.parse("${baseUrl}get_account_details.php"),
      body: {
        "email": email,
      },
    );

    print("RAW RESPONSE:");
    print(response.body);   // 👈 ADD THIS
    print("CALLING URL: ${baseUrl}get_account_details.php");


    return jsonDecode(response.body);
  }
}
