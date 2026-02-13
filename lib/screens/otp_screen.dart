import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> controllers =
  List.generate(6, (_) => TextEditingController());

  final List<FocusNode> focusNodes =
  List.generate(6, (_) => FocusNode());

  bool isLoading = false;

  String get combinedOtp =>
      controllers.map((c) => c.text).join();

  void moveToNext(int index) {
    if (index < 5) {
      focusNodes[index + 1].requestFocus();
    }
  }

  void moveToPrevious(int index) {
    if (index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> verifyOtp() async {
    final otp = combinedOtp;

    if (otp.length != 6) return;

    setState(() => isLoading = true);

    try {
      final result = await ApiService.verifyOtp(otp);

      if (result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (_) => const LoginScreen()),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  result['message'] ?? "Invalid OTP")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Widget buildOtpBox(int index) {
    return SizedBox(
      width: 55,
      height: 55,
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            moveToNext(index);
          }
          setState(() {});
        },
        onSubmitted: (_) {
          if (index == 5) {
            verifyOtp();
          }
        },
        onTap: () {
          controllers[index].selection =
              TextSelection.fromPosition(
                TextPosition(
                    offset:
                    controllers[index].text.length),
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFF4F6FB),

      // HEADER
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

      body: Center(
        child: Container(
          width: 520,
          padding:
          const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 40),
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
            MainAxisSize.min,
            children: [

              const Text(
                "Verify OTP",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight:
                  FontWeight.bold,
                  color:
                  Color(0xFF1F2937),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Enter the 6-digit code sent to your email",
                textAlign:
                TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Check Your Inbox",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Enter the 6-digit security code",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .center,
                children: List.generate(
                  6,
                      (index) => Padding(
                    padding:
                    const EdgeInsets
                        .symmetric(
                        horizontal:
                        6),
                    child:
                    buildOtpBox(
                        index),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style:
                  ElevatedButton
                      .styleFrom(
                    padding:
                    const EdgeInsets
                        .symmetric(
                        vertical:
                        16),
                    backgroundColor:
                    const Color(
                        0xFF2563EB),
                    foregroundColor:
                    Colors.white,
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                          10),
                    ),
                  ),
                  onPressed: combinedOtp
                      .length ==
                      6 &&
                      !isLoading
                      ? verifyOtp
                      : null,
                  child: isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child:
                    CircularProgressIndicator(
                      strokeWidth:
                      2,
                      color: Colors
                          .white,
                    ),
                  )
                      : const Text(
                    "Verify Code",
                    style:
                    TextStyle(
                      fontSize:
                      18,
                      fontWeight:
                      FontWeight
                          .bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

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
    );
  }
}
