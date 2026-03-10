import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {

  static Future<Map<String, dynamic>> login(
      String username, String password) async {

    final response = await http.post(
      Uri.parse(ApiConfig.login),
      body: {
        "username": username,
        "password": password
      },
    );

    return jsonDecode(response.body);
  }
}