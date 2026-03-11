import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sidebar.dart';

class AppLayout extends StatelessWidget {

  final Widget child;
  final String route;

  const AppLayout({
    super.key,
    required this.child,
    required this.route,
  });

  void confirmExit(BuildContext context) {

    showDialog(

      context: context,

      builder: (context) {

        return AlertDialog(

          title: const Text("Exit Application"),

          content: const Text(
              "Are you sure you want to exit EXPIROCHAIN?"
          ),

          actions: [

            TextButton(

              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("No"),

            ),

            ElevatedButton(

              onPressed: () {
                SystemNavigator.pop();
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,   // ✅ Makes "Yes" text white
              ),

              child: const Text("Yes"),

            ),

          ],

        );

      },

    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "EXPIROCHAIN",
          style: TextStyle(color: Colors.white),
        ),

        backgroundColor: const Color(0xFF0F172A),

        iconTheme: const IconThemeData(color: Colors.white),

        actions: [

          IconButton(

            icon: const Icon(Icons.logout),

            onPressed: () {
              confirmExit(context);
            },

          )

        ],

      ),

      drawer: Sidebar(currentRoute: route),

      body: child,

    );

  }

}