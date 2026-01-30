import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  final String firmName;

  const HomeScreen({
    super.key,
    required this.firmName,
  });

  // ================= LOGOUT CONFIRM DIALOG =================
  Future<bool> _showLogoutDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  // ================= EXIT CONFIRM DIALOG =================
  Future<bool> _showExitDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Exit App"),
        content: const Text("Are you sure you want to exit the application?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Exit"),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  // ================= PERFORM LOGOUT =================
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
          SystemNavigator.pop(); // ✅ Exit to mobile home
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("EXPIROCHAIN Dashboard"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final shouldLogout = await _showLogoutDialog(context);
                if (shouldLogout) {
                  await _logout(context);
                }
              },
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.business, size: 64, color: Colors.blue),
              const SizedBox(height: 16),

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
                "Welcome to EXPIROCHAIN\n\nDashboard coming soon...",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
