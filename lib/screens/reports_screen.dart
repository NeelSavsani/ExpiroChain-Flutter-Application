import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../widgets/app_layout.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {

  String selectedFormat = "pdf";
  String selectedReport = "products";

  void openExportDialog() {

    showDialog(
      context: context,
      builder: (context) {

        String tempFormat = selectedFormat;
        String tempReport = selectedReport;

        return StatefulBuilder(
          builder: (context, setStateDialog) {

            return AlertDialog(

              title: const Text("Export Reports"),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select Report",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                    RadioListTile(
                      value: "products",
                      groupValue: tempReport,
                      title: const Text("Products Report"),
                      onChanged: (value){
                        setStateDialog(() {
                          tempReport = value!;
                        });
                      },
                    ),

                    RadioListTile(
                      value: "stock",
                      groupValue: tempReport,
                      title: const Text("Stock Report"),
                      onChanged: (value){
                        setStateDialog(() {
                          tempReport = value!;
                        });
                      },
                    ),

                    const Divider(),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select Format",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                    RadioListTile(
                      value: "pdf",
                      groupValue: tempFormat,
                      title: const Text("PDF (.pdf)"),
                      onChanged: (value){
                        setStateDialog(() {
                          tempFormat = value!;
                        });
                      },
                    ),

                    RadioListTile(
                      value: "csv",
                      groupValue: tempFormat,
                      title: const Text("CSV (.csv)"),
                      onChanged: (value){
                        setStateDialog(() {
                          tempFormat = value!;
                        });
                      },
                    ),

                    RadioListTile(
                      value: "excel",
                      groupValue: tempFormat,
                      title: const Text("CSV for Excel"),
                      onChanged: (value){
                        setStateDialog(() {
                          tempFormat = value!;
                        });
                      },
                    ),

                    RadioListTile(
                      value: "doc",
                      groupValue: tempFormat,
                      title: const Text("Word (.doc)"),
                      onChanged: (value){
                        setStateDialog(() {
                          tempFormat = value!;
                        });
                      },
                    ),

                    RadioListTile(
                      value: "json",
                      groupValue: tempFormat,
                      title: const Text("JSON (.json)"),
                      onChanged: (value){
                        setStateDialog(() {
                          tempFormat = value!;
                        });
                      },
                    ),

                    RadioListTile(
                      value: "txt",
                      groupValue: tempFormat,
                      title: const Text("Plain Text (.txt)"),
                      onChanged: (value){
                        setStateDialog(() {
                          tempFormat = value!;
                        });
                      },
                    ),

                  ],
                ),
              ),

              actions: [

                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () async {

                    selectedFormat = tempFormat;
                    selectedReport = tempReport;

                    Navigator.pop(context);

                    await exportReports();

                  },
                  child: const Text("Export"),
                )

              ],

            );

          },
        );

      },
    );

  }

  Future<void> exportReports() async {

    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt("user_id") ?? 0;

    String url = await ApiService.exportReports(
        userId,
        selectedFormat,
        selectedReport
    );

    Navigator.pop(context);

    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );

  }

  @override
  Widget build(BuildContext context) {

    return AppLayout(

      route: "/reports",

      child: Container(

        color: const Color(0xFFF4F6F9),

        padding: const EdgeInsets.all(20),

        child: Card(

          child: Padding(

            padding: const EdgeInsets.all(20),

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [

                    const Text(
                      "Reports",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    ElevatedButton.icon(

                      icon: const Icon(Icons.file_download),

                      label: const Text("Export"),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                      ),

                      onPressed: openExportDialog,

                    ),

                  ],

                ),

                const SizedBox(height: 20),

                const Text(
                  "Generate and export reports for Products or Stock.",
                ),

              ],

            ),

          ),

        ),

      ),

    );

  }

}