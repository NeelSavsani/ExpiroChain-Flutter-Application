import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../widgets/custom_textfield.dart';
import '../services/api_service.dart';
import 'otp_screen.dart';
import 'login_screen.dart';

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
  String? selectedOrgType;

  String normalizeIndianPhone(String input) {
    final digitsOnly = input.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length > 10) {
      return digitsOnly.substring(digitsOnly.length - 10);
    }
    return digitsOnly;
  }

  Future<void> pickFile(Function(File) onPicked) async {
    final result =
    await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null && result.files.single.path != null) {
      onPicked(File(result.files.single.path!));
    }
  }

  Widget buildUploadBox({
    required String label,
    required File? file,
    required VoidCallback onPick,
    required VoidCallback onClear,
  }) {
    return GestureDetector(
      onTap: onPick,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: file == null
                ? Colors.grey.shade400
                : const Color(0xFF2563EB),
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Icon(
                    file == null
                        ? Icons.upload_file_outlined
                        : Icons.check_circle,
                    size: 28,
                    color: file == null
                        ? Colors.grey
                        : const Color(0xFF2563EB),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    file == null
                        ? label
                        : file.path.split('/').last,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: file == null
                          ? FontWeight.normal
                          : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (file != null)
              Positioned(
                right: 8,
                top: 0,
                child: IconButton(
                  icon: const Icon(Icons.close,
                      color: Colors.red),
                  onPressed: onClear,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> sendOtp() async {
    if (selectedOrgType == null ||
        gstFile == null ||
        dl1File == null ||
        dl2File == null ||
        passController.text.isEmpty ||
        confirmController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    if (passController.text != confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    final normalizedPhone =
    normalizeIndianPhone(phoneController.text);

    if (normalizedPhone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid mobile number")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await ApiService.sendOtpWithFiles(
        fields: {
          "firm_name": firmController.text.trim(),
          "owner_name": ownerController.text.trim(),
          "user_type": selectedOrgType!,
          "email_id": emailController.text.trim(),
          "phn_no": normalizedPhone,
          "gstno": gstNoController.text.trim(),
          "dl1": dl1NoController.text.trim(),
          "dl2": dl2NoController.text.trim(),
          "address": addressController.text.trim(),
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
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => const LoginScreen()),
            );
          },
        ),
        title: const Text(
          "Register",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            CustomTextField(
              controller: firmController,
              label: "Firm Name",
              icon: Icons.store,
            ),
            const SizedBox(height: 22),

            CustomTextField(
              controller: ownerController,
              label: "Owner Name",
              icon: Icons.person,
            ),
            const SizedBox(height: 22),

            DropdownButtonFormField<String>(
              value: selectedOrgType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Organization Type",
              ),
              items: const [
                DropdownMenuItem(
                    value: "medical store",
                    child: Text("Medical Store")),
                DropdownMenuItem(
                    value: "clinic",
                    child: Text("Clinic")),
                DropdownMenuItem(
                    value: "ngo",
                    child: Text("NGO")),
              ],
              onChanged: (val) =>
                  setState(() => selectedOrgType = val),
            ),
            const SizedBox(height: 22),

            CustomTextField(
              controller: emailController,
              label: "Email Address",
              icon: Icons.email,
            ),
            const SizedBox(height: 22),

            CustomTextField(
              controller: phoneController,
              label: "Mobile Number",
              icon: Icons.phone,
            ),
            const SizedBox(height: 22),

            CustomTextField(
              controller: gstNoController,
              label: "GST Number",
              icon: Icons.badge,
            ),
            const SizedBox(height: 22),

            buildUploadBox(
              label: "Upload GST Certificate",
              file: gstFile,
              onPick: () =>
                  pickFile((f) => setState(() => gstFile = f)),
              onClear: () => setState(() => gstFile = null),
            ),
            const SizedBox(height: 22),

            CustomTextField(
              controller: addressController,
              label: "Address",
              icon: Icons.location_on,
              maxLines: 3,
            ),
            const SizedBox(height: 22),

            CustomTextField(
              controller: dl1NoController,
              label: "Drug License 1",
              icon: Icons.badge,
            ),
            const SizedBox(height: 22),

            buildUploadBox(
              label: "Upload Drug License 1",
              file: dl1File,
              onPick: () =>
                  pickFile((f) => setState(() => dl1File = f)),
              onClear: () => setState(() => dl1File = null),
            ),
            const SizedBox(height: 22),

            CustomTextField(
              controller: dl2NoController,
              label: "Drug License 2",
              icon: Icons.badge,
            ),
            const SizedBox(height: 22),

            buildUploadBox(
              label: "Upload Drug License 2",
              file: dl2File,
              onPick: () =>
                  pickFile((f) => setState(() => dl2File = f)),
              onClear: () => setState(() => dl2File = null),
            ),
            const SizedBox(height: 22),

            CustomTextField(
              controller: passController,
              label: "Password",
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 22),

            CustomTextField(
              controller: confirmController,
              label: "Confirm Password",
              icon: Icons.lock_outline,
              isPassword: true,
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor:
                  const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                ),
                onPressed:
                isLoading ? null : sendOtp,
                child: Text(
                  isLoading
                      ? "Processing..."
                      : "Register",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
