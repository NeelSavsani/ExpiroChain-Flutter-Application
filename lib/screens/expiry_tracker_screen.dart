import 'package:flutter/material.dart';
import '../widgets/app_layout.dart';

class ExpiryTrackerScreen extends StatelessWidget {
  const ExpiryTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return AppLayout(

      route: "/expiry",

      child: Container(

        color: const Color(0xFFF4F6F9),

        padding: const EdgeInsets.all(20),

        child: Card(

          child: Padding(

            padding: const EdgeInsets.all(20),

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: const [

                Text(
                  "Expiry Tracker",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 20),

                Text(
                  "Expiry tracking data will appear here",
                ),

              ],

            ),

          ),

        ),

      ),

    );

  }

}