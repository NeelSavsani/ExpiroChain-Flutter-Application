import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  final productId = TextEditingController();
  final barcode = TextEditingController();
  final productName = TextEditingController();
  final manufacturer = TextEditingController();

  bool expiryAvailable = false;

  void resetForm() {
    productId.clear();
    barcode.clear();
    productName.clear();
    manufacturer.clear();
    setState(() {
      expiryAvailable = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("EXPIROCHAIN",style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0f172a),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      drawer: const Sidebar(currentRoute: "/add-product"),

      body: Container(
        color: const Color(0xFFF4F6F9),
        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Add Product",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: productId,
                    decoration: const InputDecoration(labelText: "Product ID"),
                  ),

                  TextField(
                    controller: barcode,
                    decoration: const InputDecoration(labelText: "Barcode"),
                  ),

                  TextField(
                    controller: productName,
                    decoration: const InputDecoration(labelText: "Product Name"),
                  ),

                  TextField(
                    controller: manufacturer,
                    decoration: const InputDecoration(labelText: "Manufacturing Company"),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Checkbox(
                        value: expiryAvailable,
                        onChanged: (val){
                          setState(() {
                            expiryAvailable = val!;
                          });
                        },
                      ),
                      const Text("Expiry Available")
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [

                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563eb),
                        ),
                        child: const Text("Add"),
                      ),

                      const SizedBox(width: 10),

                      ElevatedButton(
                        onPressed: resetForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text("Reset"),
                      ),

                    ],
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}