import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await ApiService.init(); // 🔥 MUST await

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final firmName = prefs.getString('firmName') ?? '';

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    firmName: firmName,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String firmName;

  const MyApp({
    super.key,
    required this.isLoggedIn,
    required this.firmName,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EXPIROCHAIN',
      debugShowCheckedModeBanner: false,
      home: isLoggedIn
          ? HomeScreen(firmName: firmName)
          : const LoginScreen(),
    );
  }
}
