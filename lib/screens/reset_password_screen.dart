import 'package:flutter/material.dart';
import 'package:expirochain_app/services/api_service.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends State<ResetPasswordScreen> {

  final TextEditingController passController =
  TextEditingController();

  final TextEditingController confirmController =
  TextEditingController();

  bool loading = false;
  bool obscurePass = true;
  bool obscureConfirm = true;

  void resetPassword() async {
    if (passController.text.isEmpty ||
        confirmController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("All fields are required")),
      );
      return;
    }

    if (passController.text != confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final res =
      await ApiService.resetPassword(
          passController.text);

      if (res) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
              Text("Password reset successful")),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (_) => const LoginScreen()),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
              Text("Failed to reset password")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth =
        MediaQuery.of(context).size.width;

    final cardWidth =
    screenWidth < 600 ? screenWidth * 0.92 : 500.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: cardWidth,
            padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  blurRadius: 30,
                  color:
                  Colors.black.withOpacity(0.08),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Create a new password for your account",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 30),

                // 🔐 New Password
                TextField(
                  controller: passController,
                  obscureText: obscurePass,
                  decoration: InputDecoration(
                    labelText: "New Password",
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePass
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePass =
                          !obscurePass;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 🔐 Confirm Password
                TextField(
                  controller: confirmController,
                  obscureText: obscureConfirm,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirm
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureConfirm =
                          !obscureConfirm;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                    loading ? null : resetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(0xFF2563EB),
                      foregroundColor:
                      Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                    child: loading
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child:
                      CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      "Reset Password",
                      style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
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
