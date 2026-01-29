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

  // ================= FILE PICKER =================
  Future<void> pickFile(Function(File) onPicked) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      onPicked(File(result.files.single.path!));
    }
  }

  // ================= FILE TILE WIDGET =================
  Widget buildFilePickerTile({
    required String label,
    required File? file,
    required VoidCallback onPick,
    required VoidCallback onClear,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.upload_file, color: Colors.blue),
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
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CustomTextField(
                controller: firmController,
                label: "Firm Name",
                icon: Icons.store),
            const SizedBox(height: 10),

            CustomTextField(
                controller: ownerController,
                label: "Owner Name",
                icon: Icons.person),
            const SizedBox(height: 10),

            CustomTextField(
                controller: emailController,
                label: "Email",
                icon: Icons.email),
            const SizedBox(height: 10),

            CustomTextField(
                controller: phoneController,
                label: "Phone",
                icon: Icons.phone,
                keyboardType: TextInputType.phone),
            const SizedBox(height: 10),

            CustomTextField(
                controller: gstNoController,
                label: "GST Number",
                icon: Icons.confirmation_number),
            const SizedBox(height: 10),

            CustomTextField(
                controller: dl1NoController,
                label: "DL1 Number",
                icon: Icons.badge),
            const SizedBox(height: 10),

            CustomTextField(
                controller: dl2NoController,
                label: "DL2 Number",
                icon: Icons.badge_outlined),
            const SizedBox(height: 10),

            CustomTextField(
              controller: addressController,
              label: "Complete Address",
              icon: Icons.location_on,
              maxLines: 3,
            ),
            const SizedBox(height: 10),

            CustomTextField(
              controller: passController,
              label: "Password",
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 10),

            CustomTextField(
              controller: confirmController,
              label: "Confirm Password",
              icon: Icons.lock_outline,
              isPassword: true,
            ),
            const SizedBox(height: 20),

            // ================= FILE PICKERS =================
            buildFilePickerTile(
              label: "Select GST Certificate",
              file: gstFile,
              onPick: () =>
                  pickFile((f) => setState(() => gstFile = f)),
              onClear: () => setState(() => gstFile = null),
            ),
            const SizedBox(height: 8),

            buildFilePickerTile(
              label: "Select DL1 Certificate",
              file: dl1File,
              onPick: () =>
                  pickFile((f) => setState(() => dl1File = f)),
              onClear: () => setState(() => dl1File = null),
            ),
            const SizedBox(height: 8),

            buildFilePickerTile(
              label: "Select DL2 Certificate",
              file: dl2File,
              onPick: () =>
                  pickFile((f) => setState(() => dl2File = f)),
              onClear: () => setState(() => dl2File = null),
            ),

            const SizedBox(height: 24),

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
