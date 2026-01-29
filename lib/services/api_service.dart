import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

import 'api_endpoints.dart';

class ApiService {
  static final Dio dio = Dio();
  static PersistCookieJar? _persistCookieJar;

  // 🔥 Call this ONCE in main.dart with await
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();

    _persistCookieJar = PersistCookieJar(
      storage: FileStorage("${dir.path}/.cookies/"),
    );

    dio.interceptors.add(CookieManager(_persistCookieJar!));

    dio.options.connectTimeout = const Duration(seconds: 20);
    dio.options.receiveTimeout = const Duration(seconds: 20);
    dio.options.validateStatus = (status) => true;
  }

  // ======================================================
  // ================== LOGIN =============================
  // ======================================================
  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final response = await dio.post(
      ApiEndpoints.login,
      data: FormData.fromMap({
        "username": username,   // ✅ MUST MATCH PHP
        "user_pass": password,  // ✅ MUST MATCH PHP
      }),
    );

    print("LOGIN RESPONSE: ${response.data}");

    return Map<String, dynamic>.from(response.data);
  }


  // ======================================================
  // ========== REGISTER WITH FILES (OTP) =================
  // ======================================================
  static Future<Map<String, dynamic>> sendOtpWithFiles({
    required Map<String, dynamic> fields,
    required Map<String, dynamic> files,
  }) async {
    final formData = FormData.fromMap(fields);

    for (var entry in files.entries) {
      if (entry.value != null) {
        formData.files.add(
          MapEntry(
            entry.key,
            await MultipartFile.fromFile(entry.value.path),
          ),
        );
      }
    }

    final response = await dio.post(
      ApiEndpoints.sendOtp, // 🔥 MUST MATCH YOUR send_otp.php
      data: formData,
    );

    print("REGISTER SEND OTP: ${response.data}");

    return Map<String, dynamic>.from(response.data);
  }

  // ======================================================
  // ================ VERIFY REGISTER OTP =================
  // ======================================================
  static Future<Map<String, dynamic>> verifyOtp(String otp) async {
    final response = await dio.post(
      ApiEndpoints.verifyOtp,
      data: FormData.fromMap({
        "otp": otp,
      }),
    );

    print("VERIFY REGISTER OTP: ${response.data}");

    return Map<String, dynamic>.from(response.data);
  }

  // ======================================================
  // ============ FORGOT PASSWORD (SESSION) ===============
  // ======================================================

  // Step 1
  static Future<bool> sendResetOtp(String input) async {
    try {
      final response = await dio.post(
        ApiEndpoints.forgotPassword,
        data: FormData.fromMap({
          "input": input,   // 🔥 MUST MATCH PHP
        }),
      );

      print("SEND RESET OTP: ${response.data}");

      return response.data['status'] == 'success';
    } catch (e) {
      print("ERROR sendResetOtp: $e");
      return false;
    }
  }

  // Step 2
  static Future<bool> verifyResetOtp(String otp) async {
    try {
      final response = await dio.post(
        ApiEndpoints.verifyResetOtp,
        data: FormData.fromMap({
          "otp": otp,
        }),
      );

      print("VERIFY RESET OTP: ${response.data}");

      return response.data['status'] == 'success';
    } catch (e) {
      print("ERROR verifyResetOtp: $e");
      return false;
    }
  }

  // Step 3
  static Future<bool> resetPassword(String newPassword) async {
    try {
      final response = await dio.post(
        ApiEndpoints.resetPassword,
        data: FormData.fromMap({
          "new_password": newPassword, // MUST MATCH PHP
        }),
      );

      print("RESET PASSWORD RESPONSE: ${response.data}");

      return response.data['status'] == 'success';
    } catch (e) {
      print("ERROR resetPassword: $e");
      return false;
    }
  }
}
