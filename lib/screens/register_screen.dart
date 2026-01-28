import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import '../services/api_service.dart';
import 'otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final firmController = TextEditingController();
  final ownerController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final gstNoController = TextEditingController();
  final dl1NoController = TextEditingController();
  final dl2NoController = TextEditingController();
  final addressController = TextEditingController();

  final passController = TextEditingController();
  final confirmController = TextEditingController();

  File? gstFile;
  File? dl1File;
  File? dl2File;

  bool isLoading = false;

  Future<void> pickFile(Function(File) onPicked) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      onPicked(File(result.files.single.path!));
    }
  }

  Future<void> sendOtp() async {
    if (gstFile == null || dl1File == null || dl2File == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select all documents")),
      );
      return;
    }

    if (passController.text != confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await ApiService.sendOtpWithFiles(
        fields: {
          "firm_name": firmController.text,
          "owner_name": ownerController.text,
          "user_type": "Medical Store",
          "email_id": emailController.text,
          "phn_no": phoneController.text,
          "gstno": gstNoController.text,
          "dl1": dl1NoController.text,
          "dl2": dl2NoController.text,
          "address": addressController.text,
          "user_pass": passController.text,
          "re_password": confirmController.text,
        },
        files: {
          "gst_file": gstFile,
          "dl1_file": dl1File,
          "dl2_file": dl2File,
        },
      );

      if (result['status'] == 'success') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OtpScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? "OTP failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CustomTextField(controller: firmController, hint: "Firm Name", icon: Icons.store),
            const SizedBox(height: 10),

            CustomTextField(controller: ownerController, hint: "Owner Name", icon: Icons.person),
            const SizedBox(height: 10),

            CustomTextField(controller: emailController, hint: "Email", icon: Icons.email),
            const SizedBox(height: 10),

            CustomTextField(controller: phoneController, hint: "Phone", icon: Icons.phone),
            const SizedBox(height: 10),

            // ✅ GST / DL Numbers
            CustomTextField(controller: gstNoController, hint: "GST Number", icon: Icons.confirmation_number),
            const SizedBox(height: 10),

            CustomTextField(controller: dl1NoController, hint: "DL1 Number", icon: Icons.badge),
            const SizedBox(height: 10),

            CustomTextField(controller: dl2NoController, hint: "DL2 Number", icon: Icons.badge_outlined),
            const SizedBox(height: 10),

            // ✅ Address (Textarea)
            CustomTextField(
              controller: addressController,
              hint: "Complete Address",
              icon: Icons.location_on,
              maxLines: 3,
            ),
            const SizedBox(height: 10),

            // ✅ Password with Eye Toggle
            CustomTextField(
              controller: passController,
              hint: "Password",
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 10),

            CustomTextField(
              controller: confirmController,
              hint: "Confirm Password",
              icon: Icons.lock_outline,
              isPassword: true,
            ),

            const SizedBox(height: 20),

            // ✅ File Pickers
            ListTile(
              title: Text(gstFile == null ? "Select GST Certificate" : "GST Certificate Selected"),
              trailing: const Icon(Icons.attach_file),
              onTap: () => pickFile((f) => setState(() => gstFile = f)),
            ),
            ListTile(
              title: Text(dl1File == null ? "Select DL1 Certificate" : "DL1 Certificate Selected"),
              trailing: const Icon(Icons.attach_file),
              onTap: () => pickFile((f) => setState(() => dl1File = f)),
            ),
            ListTile(
              title: Text(dl2File == null ? "Select DL2 Certificate" : "DL2 Certificate Selected"),
              trailing: const Icon(Icons.attach_file),
              onTap: () => pickFile((f) => setState(() => dl2File = f)),
            ),

            const SizedBox(height: 20),

            CustomButton(
              text: isLoading ? "Sending OTP..." : "Send OTP",
              onPressed: isLoading ? () {} : sendOtp,
            ),
          ],
        ),
      ),
    );
  }
}
