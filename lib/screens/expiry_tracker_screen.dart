import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../widgets/sidebar.dart';
import '../widgets/app_layout.dart';

class ExpiryTrackerScreen extends StatefulWidget {
  const ExpiryTrackerScreen({super.key});

  @override
  State<ExpiryTrackerScreen> createState() => _ExpiryTrackerScreenState();
}

class _ExpiryTrackerScreenState extends State<ExpiryTrackerScreen> {

  bool loading = true;

  List soon = [];
  List expired = [];

  @override
  void initState() {
    super.initState();
    loadExpiry();
  }

  Future<void> loadExpiry() async {

    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt("user_id") ?? 0;

    final result = await ApiService.getExpiryTracker(userId);

    if(result["status"] == "success"){

      setState(() {
        soon = result["expiring_soon"];
        expired = result["expired"];
        loading = false;
      });

    }else{
      setState(() {
        loading = false;
      });
    }
  }

  Color getRowColor(int days){

    if(days <= 7){
      return const Color(0xFFFFE4E6); // critical
    }else{
      return const Color(0xFFFFF7ED); // warning
    }
  }

  Widget buildSoonTable(){

    if(soon.isEmpty){
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text("No medicines expiring within 30 days"),
      );
    }

    return DataTable(
      columns: const [

        DataColumn(label: Text("Name")),
        DataColumn(label: Text("Batch")),
        DataColumn(label: Text("Qty")),
        DataColumn(label: Text("Expiry")),
        DataColumn(label: Text("Days Left")),

      ],
      rows: soon.map((item){

        int days = int.parse(item["days_left"].toString());

        return DataRow(
          color: MaterialStateProperty.all(getRowColor(days)),
          cells: [

            DataCell(Text(item["prod_name"])),
            DataCell(Text(item["batch_no"])),
            DataCell(Text(item["qty"].toString())),
            DataCell(Text(item["exp_date"])),
            DataCell(
              Text(
                "$days days",
                style: TextStyle(
                  color: days <= 7 ? Colors.red : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          ],
        );

      }).toList(),
    );
  }

  Widget buildExpiredTable(){

    if(expired.isEmpty){
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text("No expired medicines"),
      );
    }

    return DataTable(
      columns: const [

        DataColumn(label: Text("Name")),
        DataColumn(label: Text("Batch")),
        DataColumn(label: Text("Qty")),
        DataColumn(label: Text("Expired On")),

      ],
      rows: expired.map((item){

        return DataRow(
          cells: [

            DataCell(Text(item["prod_name"])),
            DataCell(Text(item["batch_no"])),
            DataCell(Text(item["qty"].toString())),
            DataCell(Text(item["exp_date"])),

          ],
        );

      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      drawer: const Sidebar(currentRoute: "/expiry"),

      body: AppLayout(

        route: "/expiry",

        child: loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const Text(
                "Expiring Within 30 Days",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Card(
                elevation: 3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: buildSoonTable(),
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                "Expired Medicines",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Card(
                elevation: 3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: buildExpiredTable(),
                ),
              ),

            ],

          ),

        ),

      ),

    );

  }

}