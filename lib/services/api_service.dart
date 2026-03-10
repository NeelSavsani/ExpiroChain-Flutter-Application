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

  static Future<Map<String, dynamic>> getProducts(int userId) async {

    final url = "${ApiConfig.getProducts}?user_id=$userId";

    print("Calling API:");
    print(url);

    final response = await http.get(Uri.parse(url));

    print("Status Code: ${response.statusCode}");
    print("Body:");
    print(response.body);

    if (response.body.isEmpty) {
      throw Exception("API returned empty response");
    }

    return jsonDecode(response.body);
  }
}