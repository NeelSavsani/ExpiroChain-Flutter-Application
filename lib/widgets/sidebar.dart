import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sidebar extends StatelessWidget {

  final String currentRoute;

  const Sidebar({super.key, required this.currentRoute});

  Widget menuItem(
      BuildContext context,
      IconData icon,
      String title,
      String route,
      ) {

    bool active = currentRoute == route;

    return Container(

      color: active ? const Color(0xFF1e293b) : Colors.transparent,

      child: ListTile(

        leading: Icon(
          icon,
          color: active ? const Color(0xFF60a5fa) : Colors.white,
        ),

        title: Text(
          title,
          style: TextStyle(
            color: active ? const Color(0xFF60a5fa) : Colors.white,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),

        onTap: () {

          Navigator.pop(context);

          if (!active) {
            Navigator.pushReplacementNamed(context, route);
          }

        },

      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(

      backgroundColor: const Color(0xFF0f172a),

      child: ListView(

        padding: EdgeInsets.zero,

        children: [

          Container(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 15),
            child: const Text(
              "EXPIROCHAIN",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Divider(color: Colors.white24),

          menuItem(context, Icons.home, "Home", "/dashboard"),
          menuItem(context, Icons.add_box, "Add Product", "/add-product"),
          menuItem(context, Icons.inventory, "Products", "/products"),
          menuItem(context, Icons.add_box, "Add Stock", "/add-stock"),
          menuItem(context, Icons.store, "Stock", "/stock"),
          menuItem(context, Icons.warning, "Expiry Tracker", "/expiry"),
          menuItem(context, Icons.bar_chart, "Reports", "/reports"),

          const Divider(color: Colors.white24),

          menuItem(context, Icons.person, "Account", "/account"),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text("Logout", style: TextStyle(color: Colors.white)),

            onTap: () async {

              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();

              Navigator.pushNamedAndRemoveUntil(
                context,
                "/",
                    (route) => false,
              );

            },

          ),

        ],
      ),
    );
  }
}