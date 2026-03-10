import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/products_screen.dart';
import 'screens/add_product_screen.dart';
import 'screens/account_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/stock_screen.dart';
import 'screens/expiry_tracker_screen.dart';

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

      initialRoute: "/",

      routes: {

        "/": (context) => const LoginScreen(),
        "/dashboard": (context) => const DashboardScreen(),
        "/add-product": (context) => const AddProductScreen(),
        "/products": (context) => const ProductsScreen(),
        "/stock": (context) => const StockScreen(),
        "/expiry": (context) => const ExpiryTrackerScreen(),
        "/reports": (context) => const ReportsScreen(),
        "/account": (context) => const AccountScreen(),
      },
    );
  }
}