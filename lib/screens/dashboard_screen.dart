import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/app_layout.dart';

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

    return AppLayout(

      route: "/dashboard",

      child: Container(

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