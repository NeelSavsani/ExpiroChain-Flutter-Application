import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../widgets/sidebar.dart';
import '../widgets/app_layout.dart';

class AddStockScreen extends StatefulWidget {
  const AddStockScreen({super.key});

  @override
  State<AddStockScreen> createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {

  final barcodeController = TextEditingController();
  final prodNameController = TextEditingController();
  final batchController = TextEditingController();
  final expiryController = TextEditingController();
  final qtyController = TextEditingController();

  final FocusNode barcodeFocus = FocusNode();

  bool loading = false;
  bool expiryApplicable = true;

  @override
  void initState() {
    super.initState();

    barcodeFocus.addListener(() {
      if (!barcodeFocus.hasFocus) {
        fetchProduct(barcodeController.text);
      }
    });
  }

  /* FETCH PRODUCT BY BARCODE */

  Future<void> fetchProduct(String barcode) async {

    if (barcode.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt("user_id") ?? 0;

    final result =
    await ApiService.getProductByBarcode(userId, barcode);

    if (result["status"] == "success") {

      setState(() {

        prodNameController.text = result["prod_name"];

        expiryApplicable =
            result["expiry_applicable"].toString() == "1";

        if (!expiryApplicable) {
          expiryController.clear();
        }

      });

    } else {

      prodNameController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result["message"] ?? "Product not found"))
      );

    }

  }

  /* ADD STOCK */

  Future<void> addStock() async {

    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt("user_id") ?? 0;

    setState(() {
      loading = true;
    });

    final result = await ApiService.addStock(
      userId,
      barcodeController.text,
      batchController.text,
      expiryController.text,
      int.parse(qtyController.text),
    );

    setState(() {
      loading = false;
    });

    if (result["status"] == "success") {

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result["message"]))
      );

      barcodeController.clear();
      prodNameController.clear();
      batchController.clear();
      expiryController.clear();
      qtyController.clear();

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result["message"]))
      );

    }

  }

  @override
  void dispose() {
    barcodeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      drawer: const Sidebar(
        currentRoute: "/add-stock",
      ),

      body: AppLayout(

        route: "/add-stock",

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: Center(

            child: Container(

              width: 400,
              padding: const EdgeInsets.all(25),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10)
                ],
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Text(
                    "Add Stock",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0f172a),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /* BARCODE */

                  TextField(
                    controller: barcodeController,
                    focusNode: barcodeFocus,
                    decoration: const InputDecoration(
                      labelText: "Barcode",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /* PRODUCT NAME */

                  TextField(
                    controller: prodNameController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Product Name",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /* BATCH NUMBER */

                  TextField(
                    controller: batchController,
                    decoration: const InputDecoration(
                      labelText: "Batch Number",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /* EXPIRY DATE */

                  TextField(
                    controller: expiryController,
                    readOnly: true,
                    enabled: expiryApplicable,
                    decoration: const InputDecoration(
                      labelText: "Expiry Date",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {

                      if (!expiryApplicable) return;

                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {

                        String formattedDate =
                            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2,'0')}-${pickedDate.day.toString().padLeft(2,'0')}";

                        setState(() {
                          expiryController.text = formattedDate;
                        });

                      }

                    },
                  ),

                  const SizedBox(height: 15),

                  /* QUANTITY */

                  TextField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Quantity",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /* ADD STOCK BUTTON */

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),

                      onPressed: loading ? null : addStock,

                      child: loading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Text(
                        "Add Stock",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}