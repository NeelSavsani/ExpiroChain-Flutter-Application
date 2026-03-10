import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  void login() async {

    setState(() {
      loading = true;
    });

    final result = await ApiService.login(
      usernameController.text,
      passwordController.text,
    );

    if (result["status"] == "success") {

      String firmName = result["firm_name"];
      int userId = int.parse(result["user_id"].toString());

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("firm_name", firmName);
      await prefs.setInt("user_id", userId);

      Navigator.pushReplacementNamed(context, "/dashboard");

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed")),
      );

    }

    setState(() {
      loading = false;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("EXPIROCHAIN"),
        backgroundColor: const Color(0xFF0f172a),
      ),

      body: Center(

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: "Email / Phone",
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: loading ? null : login,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Login"),
              )

            ],
          ),
        ),
      ),
    );
  }
}