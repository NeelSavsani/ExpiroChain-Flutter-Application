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
  String? selectedOrgType;

  // ================= PHONE NORMALIZER =================
  String normalizeIndianPhone(String input) {
    final digitsOnly = input.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length > 10) {
      return digitsOnly.substring(digitsOnly.length - 10);
    }
    return digitsOnly;
  }

  // ================= FILE PICKER =================
  Future<void> pickFile(Function(File) onPicked) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      onPicked(File(result.files.single.path!));
    }
  }

  // ================= FILE TILE =================
  Widget buildFilePickerTile({
    required String label,
    required File? file,
    required VoidCallback onPick,
    required VoidCallback onClear,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.upload_file, color: Color(0xFF1565C0)),
        title: Text(
          file == null ? label : file.path.split('/').last,
          style: TextStyle(
            color: file == null ? Colors.grey[600] : Colors.black,
            fontWeight: file == null ? FontWeight.normal : FontWeight.w600,
          ),
        ),
        subtitle: file != null ? const Text("Tap to change file") : null,
        trailing: file == null
            ? const Icon(Icons.attach_file)
            : IconButton(
          icon: const Icon(Icons.close, color: Colors.red),
          onPressed: onClear,
        ),
        onTap: onPick,
      ),
    );
  }

  // ================= SEND OTP =================
  Future<void> sendOtp() async {
    if (selectedOrgType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select organization type")),
      );
      return;
    }

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

    final normalizedPhone = normalizeIndianPhone(phoneController.text);
    if (normalizedPhone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid 10-digit mobile number")),
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
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(Icons.person_add_alt_1,
                          size: 60, color: Color(0xFF1565C0)),
                      const SizedBox(height: 12),

                      const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                      const SizedBox(height: 20),

                      CustomTextField(
                        controller: firmController,
                        label: "Firm Name",
                        icon: Icons.store,
                      ),
                      const SizedBox(height: 12),

                      CustomTextField(
                        controller: ownerController,
                        label: "Owner Name",
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 12),

                      DropdownButtonFormField<String>(
                        value: selectedOrgType,
                        decoration: InputDecoration(
                          labelText: "Organization Type",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.business),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "medical store",
                            child: Text("Medical Store"),
                          ),
                          DropdownMenuItem(
                            value: "clinic",
                            child: Text("Clinic"),
                          ),
                          DropdownMenuItem(
                            value: "ngo",
                            child: Text("NGO"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() => selectedOrgType = value);
                        },
                      ),
                      const SizedBox(height: 12),

                      CustomTextField(
                        controller: emailController,
                        label: "Email",
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 12),

                      CustomTextField(
                        controller: phoneController,
                        label: "Phone",
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),

                      CustomTextField(
                        controller: gstNoController,
                        label: "GST Number",
                        icon: Icons.confirmation_number,
                      ),
                      const SizedBox(height: 12),

                      CustomTextField(
                        controller: dl1NoController,
                        label: "DL1 Number",
                        icon: Icons.badge,
                      ),
                      const SizedBox(height: 12),

                      CustomTextField(
                        controller: dl2NoController,
                        label: "DL2 Number",
                        icon: Icons.badge_outlined,
                      ),
                      const SizedBox(height: 12),

                      CustomTextField(
                        controller: addressController,
                        label: "Complete Address",
                        icon: Icons.location_on,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 12),

                      CustomTextField(
                        controller: passController,
                        label: "Password",
                        icon: Icons.lock,
                        isPassword: true,
                      ),
                      const SizedBox(height: 12),

                      CustomTextField(
                        controller: confirmController,
                        label: "Confirm Password",
                        icon: Icons.lock_outline,
                        isPassword: true,
                      ),
                      const SizedBox(height: 20),

                      buildFilePickerTile(
                        label: "Upload GST Certificate",
                        file: gstFile,
                        onPick: () =>
                            pickFile((f) => setState(() => gstFile = f)),
                        onClear: () => setState(() => gstFile = null),
                      ),
                      const SizedBox(height: 8),

                      buildFilePickerTile(
                        label: "Upload DL1 Certificate",
                        file: dl1File,
                        onPick: () =>
                            pickFile((f) => setState(() => dl1File = f)),
                        onClear: () => setState(() => dl1File = null),
                      ),
                      const SizedBox(height: 8),

                      buildFilePickerTile(
                        label: "Upload DL2 Certificate",
                        file: dl2File,
                        onPick: () =>
                            pickFile((f) => setState(() => dl2File = f)),
                        onClear: () => setState(() => dl2File = null),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text:
                          isLoading ? "Sending OTP..." : "Send OTP",
                          onPressed: isLoading ? () {} : sendOtp,
                        ),
                      ),

                      if (isLoading) ...[
                        const SizedBox(height: 14),
                        const CircularProgressIndicator(strokeWidth: 2),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
