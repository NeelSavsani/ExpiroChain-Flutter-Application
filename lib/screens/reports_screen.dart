import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
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

/* ===================================== OPEN EXPORT DIALOG ===================================== */

  void openExportDialog() {

    String tempFormat = selectedFormat;
    String tempReport = selectedReport;

    showDialog(
      context: context,
      builder: (context) {

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

                    RadioListTile<String>(
                      title: const Text("Products Report"),
                      value: "products",
                      groupValue: tempReport,
                      onChanged: (value){
                        setStateDialog(() {
                          tempReport = value!;
                        });
                      },
                    ),

                    RadioListTile<String>(
                      title: const Text("Stock Report"),
                      value: "stock",
                      groupValue: tempReport,
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

                    buildFormat("pdf","PDF (.pdf)",tempFormat,setStateDialog),
                    buildFormat("csv","CSV (.csv)",tempFormat,setStateDialog),
                    buildFormat("excel","CSV for Excel",tempFormat,setStateDialog),
                    buildFormat("doc","Word (.doc)",tempFormat,setStateDialog),
                    buildFormat("json","JSON (.json)",tempFormat,setStateDialog),
                    buildFormat("txt","Plain Text (.txt)",tempFormat,setStateDialog),

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

/* ===================================== FORMAT RADIO BUILDER ===================================== */

  Widget buildFormat(String value,String label,String group,Function setStateDialog){

    return RadioListTile<String>(
      value: value,
      groupValue: group,
      title: Text(label),
      onChanged: (v){
        setStateDialog(() {
          selectedFormat = v!;
        });
      },
    );

  }

/* ===================================== EXPORT REPORT FUNCTION ===================================== */

  Future<void> exportReports() async {

    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt("user_id") ?? 0;

    String url = ApiService.exportReports(userId,selectedFormat,selectedReport );

    try{

/* REQUEST STORAGE PERMISSION */

      var status = await Permission.manageExternalStorage.request();

      if(!status.isGranted){

        if(!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Storage permission required")),
        );

        return;

      }

/* DOWNLOAD DIRECTORY */

      Directory downloadDir = Directory("/storage/emulated/0/Download");

      String extension =
      selectedFormat == "excel" ? "csv" : selectedFormat;

      String fileName =
          "${selectedReport}_report.$extension";

      String filePath =
          "${downloadDir.path}/$fileName";

/* DOWNLOAD FILE */

      Dio dio = Dio();

      Response response = await dio.download(
        url,
        filePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

/* VERIFY FILE SIZE */

      File file = File(filePath);

      if(await file.length() == 0){

        if(!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("File download failed")),
        );

        return;

      }

      if(!mounted) return;

/* SUCCESS MESSAGE */

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Saved in Downloads: $fileName")),
      );

/* OPEN FILE */

      await OpenFilex.open(filePath);

    }
    catch(e){

      if(!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download failed: $e")),
      );

    }

  }

/* ===================================== UI ===================================== */

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