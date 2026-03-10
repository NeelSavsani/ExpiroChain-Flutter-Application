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

  static Future<Map<String, dynamic>> getAccount(int userId) async {

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/get_account.php?user_id=$userId"),
    );

    return jsonDecode(response.body);

  }
}