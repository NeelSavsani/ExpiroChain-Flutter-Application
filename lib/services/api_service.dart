import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import '../core/api_endpoints.dart';

class ApiService {
  static final Dio _dio = Dio();
  static final CookieJar _cookieJar = CookieJar();

  static void init() {
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  // ---------- LOGIN ----------
  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: FormData.fromMap({
        'username': username,
        'user_pass': password,
      }),
    );

    return response.data;
  }

  // ---------- SEND OTP + FILES (CRITICAL) ----------
  static Future<Map<String, dynamic>> sendOtpWithFiles({
    required Map<String, String> fields,
    required File gstFile,
    required File dl1File,
    required File dl2File,
  }) async {
    final formData = FormData.fromMap({
      ...fields,
      'gst_file': await MultipartFile.fromFile(gstFile.path),
      'dl1_file': await MultipartFile.fromFile(dl1File.path),
      'dl2_file': await MultipartFile.fromFile(dl2File.path),
    });

    final response = await _dio.post(
      ApiEndpoints.sendOtp,
      data: formData,
    );

    return response.data;
  }

  // ---------- VERIFY OTP ----------
  static Future<Map<String, dynamic>> verifyOtp(String otp) async {
    final response = await _dio.post(
      ApiEndpoints.verifyOtp,
      data: FormData.fromMap({
        'otp': otp,
      }),
    );

    return response.data;
  }
}
