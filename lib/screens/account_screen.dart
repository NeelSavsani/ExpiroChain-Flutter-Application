import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {

      // 🔥 GET SAVED EMAIL
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email') ?? '';

      print("Saved Email: $email");

      if (email.isEmpty) {
        setState(() => isLoading = false);
        return;
      }

      final result = await ApiService.getAccountDetails(email);

      print("API Response: $result"); // 🔥 ALSO ADD THIS

      if (!mounted) return;

      if (result['status'] == 'success') {
        setState(() {
          userData = result['data'];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }

    } catch (e) {
      print("Error: $e"); // 🔥 ADD THIS TOO
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Widget buildTile(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(title),
        subtitle: Text(value.isEmpty ? "Not available" : value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Details"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
          ? const Center(child: Text("No data found"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            buildTile("Firm Name", userData!['firm_name'] ?? ''),
            buildTile("Owner Name", userData!['owner_name'] ?? ''),
            buildTile("Email", userData!['email_id'] ?? ''),
            buildTile("Mobile", userData!['phn_no'] ?? ''),
            buildTile("Address", userData!['address'] ?? ''),
            buildTile("GST Number", userData!['gstno'] ?? ''),
            buildTile("DL1", userData!['dl1'] ?? ''),
            buildTile("DL2", userData!['dl2'] ?? ''),
            buildTile("User Type", userData!['user_type'] ?? ''),

          ],
        ),
      ),
    );
  }
}
