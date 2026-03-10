import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/sidebar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

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

      drawer: const Sidebar(currentRoute: "/dashboard"),

      body: Container(
        width: double.infinity,
        color: const Color(0xFFF4F6F9),

        child: Center(
          child: Text(
            "$firmName, Welcome to EXPIROCHAIN",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}