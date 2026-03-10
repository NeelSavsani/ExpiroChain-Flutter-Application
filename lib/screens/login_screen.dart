import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loading = false;

  Future<void> login() async {

    if(usernameController.text.isEmpty || passwordController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter username and password"))
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {

      final result = await ApiService.login(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );

      if (result["status"] == "success") {

        String firmName = result["firm_name"];
        int userId = int.parse(result["user_id"].toString());

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString("firm_name", firmName);
        await prefs.setInt("user_id", userId);

        if(!mounted) return;

        Navigator.pushReplacementNamed(context, "/dashboard");

      } else {

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid login credentials"))
        );

      }

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Server error. Please try again."))
      );

      debugPrint(e.toString());

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

        child: SingleChildScrollView(

          child: Padding(
            padding: const EdgeInsets.all(25),

            child: Container(
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
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 25),

                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: "Email / Phone",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,

                      child: ElevatedButton(
                        onPressed: loading ? null : login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: loading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      )
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}