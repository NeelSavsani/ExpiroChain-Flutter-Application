import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import '../widgets/custom_textfield.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> doLogin() async {
    FocusScope.of(context).unfocus();

    final email = emailController.text.trim();
    final pass = passwordController.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await ApiService.login(email, pass);

      if (result['status'] == 'success') {
        final firmName = result['user']['firm_name'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('firmName', firmName);
        await prefs.setString('email', email);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(firmName: firmName),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? "Login failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),

      // ================= APP BAR (NO ARROW) =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        automaticallyImplyLeading: false, // 🚫 removes arrow
        title: const Text(
          "EXPIROCHAIN",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),

            const Text(
              "Welcome Back",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Sign in to continue",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 40),

            Center(
              child: Container(
                width: 450,
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 25,
                      color: Colors.black12,
                    )
                  ],
                ),
                child: Column(
                  children: [

                    CustomTextField(
                      controller: emailController,
                      label: "Email or Phone Number",
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: passwordController,
                      label: "Password",
                      icon: Icons.lock,
                      isPassword: true,
                    ),

                    const SizedBox(height: 8),

                    // FORGOT PASSWORD CENTERED (LESS SPACE)
                    Center(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Color(0xFF2563EB),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // LOGIN BUTTON (PRIMARY)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding:
                          const EdgeInsets.symmetric(
                              vertical: 16),
                          backgroundColor:
                          const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
                        ),
                        onPressed:
                        isLoading ? null : doLogin,
                        child: Text(
                          isLoading
                              ? "Logging in..."
                              : "Login",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // CREATE NEW ACCOUNT (SMALLER)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding:
                          const EdgeInsets.symmetric(
                              vertical: 12),
                          side: const BorderSide(
                            color: Color(0xFF2563EB),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Create New Account",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ),
                    ),

                    if (isLoading) ...[
                      const SizedBox(height: 14),
                      const CircularProgressIndicator(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
