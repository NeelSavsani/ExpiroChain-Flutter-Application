import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/products_screen.dart';
import 'screens/add_product_screen.dart';
import 'screens/account_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/stock_screen.dart';
import 'screens/expiry_tracker_screen.dart';
import 'screens/add_stock_screen.dart';

void main() {
  runApp(const ExpiroChainApp());
}

class ExpiroChainApp extends StatelessWidget {
  const ExpiroChainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "EXPIROCHAIN",
      theme: ThemeData(
        primaryColor: const Color(0xFF0F172A),
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
        fontFamily: 'Segoe UI',
      ),
      home: const CheckLogin(),
      routes: {
        "/login": (context) => const LoginScreen(),
        "/dashboard": (context) => const DashboardScreen(),
        "/add-product": (context) => const AddProductScreen(),
        "/products": (context) => const ProductsScreen(),
        "/stock": (context) => const StockScreen(),
        "/expiry": (context) => const ExpiryTrackerScreen(),
        "/reports": (context) => const ReportsScreen(),
        "/account": (context) => const AccountScreen(),
        "/add-stock": (context) => const AddStockScreen(),
      },
    );
  }
}

class CheckLogin extends StatefulWidget {
  const CheckLogin({super.key});

  @override
  State<CheckLogin> createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {

  Future<bool> checkLoginStatus() async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool("is_logged_in") ?? false;

  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(

      future: checkLoginStatus(),

      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          return const DashboardScreen();
        } else {
          return const LoginScreen();
        }

      },

    );

  }

}