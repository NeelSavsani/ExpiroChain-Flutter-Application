import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';

class ExpiryTrackerScreen extends StatelessWidget {

  const ExpiryTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("EXPIROCHAIN",style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0f172a),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      drawer: const Sidebar(currentRoute: "/expiry"),

      body: Container(
        color: const Color(0xFFF4F6F9),
        padding: const EdgeInsets.all(20),

        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: const [

                Text(
                  "Expiry Tracker",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 20),

                Text("Expiry tracking data will appear here")

              ],
            ),
          ),
        ),
      ),
    );
  }
}