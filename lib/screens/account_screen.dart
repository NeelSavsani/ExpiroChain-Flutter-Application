import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/sidebar.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  String firmName = "";

  @override
  void initState() {
    super.initState();
    loadFirmName();
  }

  void loadFirmName() async {

    final prefs = await SharedPreferences.getInstance();

    setState(() {
      firmName = prefs.getString("firm_name") ?? "";
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "EXPIROCHAIN",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0f172a),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      drawer: const Sidebar(currentRoute: "/account"),

      body: Container(
        width: double.infinity,
        color: const Color(0xFFF4F6F9),
        padding: const EdgeInsets.all(20),

        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "Account",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0f172a),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  "Firm Name: $firmName",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF334155),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}