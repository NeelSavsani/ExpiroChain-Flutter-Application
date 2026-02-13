import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';
import 'account_screen.dart';

class HomeScreen extends StatelessWidget {
  final String firmName;

  const HomeScreen({
    super.key,
    required this.firmName,
  });

  // ================= LOGOUT CONFIRM =================
  Future<bool> _showLogoutDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // ================= EXIT CONFIRM =================
  Future<bool> _showExitDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text("Exit App"),
        content: const Text("Are you sure you want to exit the application?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Exit",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // ================= LOGOUT FUNCTION =================
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await _showExitDialog(context);
        if (shouldExit) {
          SystemNavigator.pop();
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "EXPIROCHAIN Dashboard",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final shouldLogout = await _showLogoutDialog(context);
                if (shouldLogout) {
                  await _logout(context);
                }
              },
            ),
          ],
        ),

        // ================= LEFT DRAWER =================
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFF2563EB),
                ),
                accountName: Text(
                  firmName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                accountEmail:
                const Text("Welcome to EXPIROCHAIN"),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.business,
                    color: Color(0xFF2563EB),
                    size: 30,
                  ),
                ),
              ),

              // ACCOUNT
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text("Account"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AccountScreen(),
                    ),
                  );
                },
              ),

              // BARCODE
              ListTile(
                leading: const Icon(Icons.qr_code_scanner),
                title: const Text("BarCode"),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("BarCode feature coming soon"),
                    ),
                  );
                },
              ),

              const Spacer(),
              const Divider(),

              // LOGOUT (Drawer Option)
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final shouldLogout =
                  await _showLogoutDialog(context);
                  if (shouldLogout) {
                    await _logout(context);
                  }
                },
              ),
            ],
          ),
        ),

        // ================= BODY =================
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.business,
                  size: 70,
                  color: Color(0xFF2563EB),
                ),
                const SizedBox(height: 20),
                Text(
                  "Welcome, $firmName 👋",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Dashboard coming soon...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
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
