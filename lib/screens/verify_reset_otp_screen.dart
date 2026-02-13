import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import 'reset_password_screen.dart';

class VerifyResetOtpScreen extends StatefulWidget {
  const VerifyResetOtpScreen({super.key});

  @override
  State<VerifyResetOtpScreen> createState() =>
      _VerifyResetOtpScreenState();
}

class _VerifyResetOtpScreenState
    extends State<VerifyResetOtpScreen> {

  final List<TextEditingController> controllers =
  List.generate(6, (_) => TextEditingController());

  final List<FocusNode> focusNodes =
  List.generate(6, (_) => FocusNode());

  bool isLoading = false;

  bool get isOtpComplete =>
      controllers.every((c) => c.text.isNotEmpty);

  String get combinedOtp =>
      controllers.map((c) => c.text).join();

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void verifyOtp() async {
    if (!isOtpComplete) return;

    setState(() => isLoading = true);

    try {
      final result =
      await ApiService.verifyResetOtp(combinedOtp);

      if (result) {
        if (!mounted) return;

        // ✅ Redirect to Reset Password Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const ResetPasswordScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid OTP")),
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

  Widget buildOtpBox(int index) {
    return TextField(
      controller: controllers[index],
      focusNode: focusNodes[index],
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      maxLength: 1,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly
      ],
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        counterText: "",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF2563EB),
            width: 2,
          ),
        ),
      ),
      onChanged: (value) {

        // Move forward
        if (value.isNotEmpty) {
          if (index < 5) {
            focusNodes[index + 1].requestFocus();
          } else {
            focusNodes[index].unfocus();
          }
        }

        // Move backward
        if (value.isEmpty && index > 0) {
          focusNodes[index - 1].requestFocus();
        }

        setState(() {});
      },
    );
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
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  blurRadius: 30,
                  color: Colors.black.withOpacity(0.08),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Verify OTP",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Enter the 6 digit code sent to your email",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 28),

                // ✅ 6 Boxes Single Line (Responsive)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final boxWidth =
                        (constraints.maxWidth - 40) / 6;

                    return Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                            (index) => SizedBox(
                          width: boxWidth,
                          height: 55,
                          child: buildOtpBox(index),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                    isOtpComplete && !isLoading
                        ? verifyOtp
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
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
                      "Verify Code",
                      style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "OTP is valid for 5 minutes",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
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
