import 'package:flutter/material.dart';
import 'package:expirochain_app/services/api_service.dart';
import 'verify_reset_otp_screen.dart';
import 'login_screen.dart';
import 'package:expirochain_app/widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final TextEditingController inputController =
  TextEditingController();

  bool loading = false;

  void sendOtp() async {
    final input = inputController.text.trim();

    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Enter email or mobile number")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final success =
      await ApiService.sendResetOtp(input);

      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
            const VerifyResetOtpScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
              content: Text(
                  "User not found or OTP failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFF4F6FB),

      // ================= HEADER =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "EXPIROCHAIN",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),

      // ================= CENTERED BODY =================
      body: Center(
        child: Container(
          width: 450,
          padding: const EdgeInsets.symmetric(
              horizontal: 40, vertical: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                blurRadius: 25,
                color: Colors.black12,
              )
            ],
          ),
          child: Column(
            mainAxisSize:
            MainAxisSize.min, // 🔥 Important
            children: [

              const Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Enter your registered email or mobile number to receive an OTP",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              CustomTextField(
                controller: inputController,
                label: "Email or Mobile Number",
                icon: Icons.person,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style:
                  ElevatedButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(
                        vertical: 16),
                    backgroundColor:
                    const Color(0xFF2563EB),
                    foregroundColor:
                    Colors.white,
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                          10),
                    ),
                  ),
                  onPressed:
                  loading ? null : sendOtp,
                  child: loading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    "Send OTP",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  const Text(
                    "Remembered your password? ",
                    style: TextStyle(
                        fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Login here",
                      style: TextStyle(
                        fontSize: 14,
                        color:
                        Color(0xFF2563EB),
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
