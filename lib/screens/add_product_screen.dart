import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../widgets/app_layout.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  final barcode = TextEditingController();
  final productName = TextEditingController();
  final manufacturer = TextEditingController();

  String category = "";
  bool expiryAvailable = false;
  bool loading = false;

  /* RESET FORM */

  void resetForm(){
    barcode.clear();
    productName.clear();
    manufacturer.clear();

    setState(() {
      category = "";
      expiryAvailable = false;
    });
  }

  /* ADD PRODUCT */

  Future<void> addProduct() async {

    if(barcode.text.isEmpty || productName.text.isEmpty || category.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill required fields"))
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try{

      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt("user_id") ?? 0;

      final result = await ApiService.addProduct(
          userId,
          barcode.text.trim(),
          productName.text.trim(),
          category,
          manufacturer.text.trim(),
          expiryAvailable ? 1 : 0
      );

      if(result["status"] == "success"){

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result["message"]))
        );

        resetForm();

      }else{

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result["message"]))
        );

      }

    }catch(e){

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Server error"))
      );

    }

    setState(() {
      loading = false;
    });

  }

  @override
  Widget build(BuildContext context) {

    return AppLayout(

      route: "/add-product",

      child: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: Center(

            child: Container(

              width: 500,
              padding: const EdgeInsets.all(25),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10)
                ],
              ),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  const Text(
                    "Add Product",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  const SizedBox(height: 20),

                  /* BARCODE */

                  TextField(
                    controller: barcode,
                    decoration: const InputDecoration(
                      labelText: "Barcode",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /* PRODUCT NAME */

                  TextField(
                    controller: productName,
                    decoration: const InputDecoration(
                      labelText: "Product Name",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /* CATEGORY */

                  DropdownButtonFormField<String>(

                    value: category.isEmpty ? null : category,

                    decoration: const InputDecoration(
                      labelText: "Product Type",
                      border: OutlineInputBorder(),
                    ),

                    items: const [

                      DropdownMenuItem(
                        value: "Medicine",
                        child: Text("Medicine"),
                      ),

                      DropdownMenuItem(
                        value: "Cosmetic",
                        child: Text("Cosmetic"),
                      ),

                      DropdownMenuItem(
                        value: "Other",
                        child: Text("Other"),
                      ),

                    ],

                    onChanged: (value){
                      setState(() {
                        category = value!;
                      });
                    },

                  ),

                  const SizedBox(height: 15),

                  /* MANUFACTURER */

                  TextField(
                    controller: manufacturer,
                    decoration: const InputDecoration(
                      labelText: "Manufacturer",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /* EXPIRY CHECKBOX */

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

                      const Text("Expiry Applicable")

                    ],
                  ),

                  const SizedBox(height: 20),

                  /* BUTTONS */

                  Row(

                    children: [

                      ElevatedButton(

                        onPressed: loading ? null : addProduct,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                        ),

                        child: loading
                            ? const SizedBox(
                          height:18,
                          width:18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth:2,
                          ),
                        )
                            : const Text("Add"),

                      ),

                      const SizedBox(width:10),

                      ElevatedButton(

                        onPressed: resetForm,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),

                        child: const Text("Reset"),

                      )

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