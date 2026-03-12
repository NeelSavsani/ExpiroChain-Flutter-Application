import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/app_layout.dart';
import '../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  String firmName = "";

  int totalProducts = 0;
  int totalStocks = 0;
  int totalMedicine = 0;
  int totalCosmetic = 0;
  int totalOther = 0;
  int nearExpiry = 0;
  int expired = 0;
  int nearlySold = 0;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {

    final prefs = await SharedPreferences.getInstance();
    firmName = prefs.getString("firm_name") ?? "";
    int userId = prefs.getInt("user_id") ?? 0;

    try {

      final result = await ApiService.getDashboard(userId);

      setState(() {

        totalProducts = result["total_products"];
        totalStocks = result["total_stock"];
        totalMedicine = result["total_medicine"];
        totalCosmetic = result["total_cosmetic"];
        totalOther = result["total_other"];
        nearExpiry = result["near_expiry"];
        expired = result["expired"];
        nearlySold = result["nearly_expiry_sold"];

        loading = false;

      });

    } catch (e) {
      loading = false;
    }

  }

  Widget statBox(String title, int value) {

    return Container(

      height: 95,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 6
          )
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(
            title,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600
            ),
          ),

          const SizedBox(height: 8),

          Text(
            value.toString(),
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2563EB)
            ),
          )

        ],
      ),
    );

  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    double containerWidth = size.width * 0.8;

    return AppLayout(

      route: "/dashboard",

      child: Container(
        width: double.infinity,
        color: const Color(0xFFF4F6F9),

        child: loading
            ? const Center(child: CircularProgressIndicator())

            : Center(

          child: Column(

            children: [

              const SizedBox(height: 20),

/* WELCOME CONTAINER */

              Container(

                width: containerWidth,
                height: size.height * 0.2,

                alignment: Alignment.center,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10
                    )
                  ],
                ),

                child: Text(
                  "Welcome, $firmName",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                  ),
                ),

              ),

              const SizedBox(height: 10),

/* GRID STATS */

              SizedBox(

                width: containerWidth,

                child: Column(

                  children: [

/* ROW 1 */

                    Row(
                      children: [

                        Expanded(child: statBox("Total Products", totalProducts)),

                        const SizedBox(width: 10),

                        Expanded(child: statBox("Total Stocks", totalStocks)),

                      ],
                    ),

                    const SizedBox(height: 10),

/* ROW 2 */

                    Row(
                      children: [

                        Expanded(child: statBox("Total Medicines", totalMedicine)),

                        const SizedBox(width: 10),

                        Expanded(child: statBox("Total Cosmetics", totalCosmetic)),

                      ],
                    ),

                    const SizedBox(height: 10),

/* ROW 3 */

                    Row(
                      children: [

                        Expanded(child: statBox("Total Others", totalOther)),

                        const SizedBox(width: 10),

                        Expanded(child: statBox("Near Expiry", nearExpiry)),

                      ],
                    ),

                    const SizedBox(height: 10),

/* ROW 4 */

                    Row(
                      children: [

                        Expanded(child: statBox("Nearly Expiry Sold", nearlySold)),

                        const SizedBox(width: 10),

                        Expanded(child: statBox("Total Expired", expired)),

                      ],
                    ),

                  ],

                ),

              )

            ],

          ),

        ),

      ),

    );

  }

}