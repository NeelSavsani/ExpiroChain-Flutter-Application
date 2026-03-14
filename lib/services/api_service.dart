import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {

  /* LOGIN */
  static Future<Map<String, dynamic>> login(
      String username,
      String password) async {

    final response = await http.post(
      Uri.parse(ApiConfig.login),
      body: {
        "username": username,
        "password": password
      },
    );

    return jsonDecode(response.body);
  }

  /* GET ACCOUNT */
  static Future<Map<String, dynamic>> getAccount(int userId) async {

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/get_account_api.php?user_id=$userId"),
    );

    return jsonDecode(response.body);
  }

  /* GET PRODUCTS */
  static Future<Map<String, dynamic>> getProducts(int userId) async {

    final response = await http.get(
      Uri.parse("${ApiConfig.getProducts}?user_id=$userId"),
    );

    return jsonDecode(response.body);
  }

  /* GET STOCK */
  static Future<Map<String, dynamic>> getStocks(int userId) async {

    final response = await http.get(
      Uri.parse("${ApiConfig.getStocks}?user_id=$userId"),
    );

    return jsonDecode(response.body);
  }

  /* ADD PRODUCT */
  static Future<Map<String, dynamic>> addProduct(
      int userId,
      String barcode,
      String prodName,
      String category,
      String manufacturer,
      int expiryApplicable) async {

    final response = await http.post(
      Uri.parse(ApiConfig.addProduct),
      body: {
        "user_id": userId.toString(),
        "barcode": barcode,
        "prod_name": prodName,
        "category": category,
        "manufacturer": manufacturer,
        "expiry_applicable": expiryApplicable.toString(),
      },
    );

    return jsonDecode(response.body);
  }

  /* ADD STOCK */
  static Future<Map<String, dynamic>> addStock(
      int userId,
      String barcode,
      String batchNo,
      String expDate,
      int qty) async {

    final response = await http.post(
      Uri.parse(ApiConfig.addStock),
      body: {
        "user_id": userId.toString(),
        "barcode": barcode,
        "batch_no": batchNo,
        "exp_date": expDate,
        "qty": qty.toString(),
      },
    );

    return jsonDecode(response.body);
  }

  /* GET PRODUCT BY BARCODE */
  static Future<Map<String, dynamic>> getProductByBarcode(
      int userId,
      String barcode) async {

    final response = await http.get(
      Uri.parse(
          "${ApiConfig.getProductByBarcode}?user_id=$userId&barcode=$barcode"),
    );

    return jsonDecode(response.body);
  }

  /* GET EXPIRY TRACKER */
  static Future<Map<String, dynamic>> getExpiryTracker(int userId) async {

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/get_expiry_tracker_api.php?user_id=$userId"),
    );

    return jsonDecode(response.body);
  }

  /* EXPORT REPORT URL */
  static String exportReports(
      int userId,
      String type,
      String table) {

    return "${ApiConfig.exportReports}"
        "?user_id=$userId&type=$type&table=$table";
  }


  /*  GET DASHBOARD */
  static Future<Map<String,dynamic>> getDashboard(int userId) async {

    final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/get_dashboard_api.php?user_id=$userId")
    );

    return jsonDecode(response.body);
  }

}