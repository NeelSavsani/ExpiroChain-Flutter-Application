import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../services/api_service.dart';
import '../widgets/app_layout.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  Map account = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadAccount();
  }

  void loadAccount() async {

    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt("user_id") ?? 0;

    final result = await ApiService.getAccount(userId);

    if(result["status"] == "success"){
      setState(() {
        account = result["data"];
        loading = false;
      });
    }
  }

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat("dd MMM yyyy • hh:mm a").format(parsedDate);
  }

  Widget buildRow(String title, String value){

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),

      child: Row(

        children: [

          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),

        ],

      ),
    );

  }

  @override
  Widget build(BuildContext context) {

    return AppLayout(

      route: "/account",

      child: loading
          ? const Center(child: CircularProgressIndicator())
          : Container(

        padding: const EdgeInsets.all(20),
        color: const Color(0xFFF4F6F9),

        child: Center(

          child: Container(

            width: 600,
            padding: const EdgeInsets.all(25),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                )
              ],
            ),

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const Text(
                  "Account Information",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0f172a),
                  ),
                ),

                const SizedBox(height: 20),

                buildRow("Firm Name", account["firm_name"] ?? ""),
                buildRow("Owner Name", account["owner_name"] ?? ""),
                buildRow("Phone Number", account["phone"] ?? ""),
                buildRow("Email ID", account["email"] ?? ""),
                buildRow("Address", account["address"] ?? ""),

                buildRow(
                  "Registered At",
                  account["registered_at"] != null
                      ? formatDate(account["registered_at"])
                      : "",
                ),

                buildRow("Organization Type", account["organization_type"] ?? ""),
                buildRow("GST No", account["gstno"] ?? ""),
                buildRow("DL1 No", account["dl1no"] ?? ""),
                buildRow("DL2 No", account["dl2no"] ?? ""),

              ],

            ),

          ),

        ),

      ),

    );

  }

}