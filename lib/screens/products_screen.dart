import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import '../widgets/app_layout.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {

  List<dynamic> products = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {

    try {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt("user_id");

      if(userId == null){
        print("User ID not found in SharedPreferences");
        setState(() { loading = false; });
        return;
      }

      final result = await ApiService.getProducts(userId);

      if(result["status"] == "success"){

        setState(() {
          products = List.from(result["products"]);
          loading = false;
        });

      } else {

        setState(() { loading = false; });

      }

    } catch(e) {

      print("ERROR: $e");

      setState(() {
        loading = false;
      });

    }

  }

  String formatDate(String date){

    DateTime parsed = DateTime.parse(date);

    return DateFormat("dd MMM yyyy • hh:mm a").format(parsed);

  }

  Widget expiryBadge(int value){

    if(value == 1){

      return Container(

        padding: const EdgeInsets.symmetric(horizontal:8,vertical:3),

        decoration: BoxDecoration(
          color: const Color(0xFFDCFCE7),
          borderRadius: BorderRadius.circular(6),
        ),

        child: const Text(
          "Yes",
          style: TextStyle(
            color: Color(0xFF166534),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),

      );

    }

    return Container(

      padding: const EdgeInsets.symmetric(horizontal:8,vertical:3),

      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(6),
      ),

      child: const Text(
        "No",
        style: TextStyle(
          color: Color(0xFF991B1B),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),

    );

  }

  Widget tableHeader(){

    return Container(

      padding: const EdgeInsets.symmetric(vertical:12),

      color: const Color(0xFF0F172A),

      child: const Row(

        children: [

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal:10),
              child: Text("Barcode",style: TextStyle(color: Colors.white)),
            ),
          ),

          Expanded(child: Text("Product Name",style: TextStyle(color: Colors.white))),
          Expanded(child: Text("Category",style: TextStyle(color: Colors.white))),
          Expanded(child: Text("Manufacturer",style: TextStyle(color: Colors.white))),
          Expanded(child: Text("Expiry",style: TextStyle(color: Colors.white))),
          Expanded(child: Text("Created At",style: TextStyle(color: Colors.white))),

        ],

      ),

    );

  }

  Widget productRow(product){

    return Container(

      padding: const EdgeInsets.symmetric(vertical:14),

      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),

      child: Row(

        children: [

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:10),
              child: Text(product["barcode"]),
            ),
          ),

          Expanded(
            child: Text(
              product["prod_name"].toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Expanded(child: Text(product["category"])),

          Expanded(
            child: Text(product["manufacturer"]?.toString() ?? "—"),
          ),

          Expanded(
            child: expiryBadge(
              int.parse(product["expiry_applicable"].toString()),
            ),
          ),

          Expanded(
            child: Text(
              formatDate(product["created_at"].toString()),
            ),
          ),

        ],

      ),

    );

  }

  @override
  Widget build(BuildContext context) {

    return AppLayout(

      route: "/products",

      child: Container(

        color: const Color(0xFFF4F6F9),

        padding: const EdgeInsets.all(20),

        child: loading

            ? const Center(child: CircularProgressIndicator())

            : Container(

          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 8)
            ],
          ),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [

                  const Text(
                    "Products",
                    style: TextStyle(
                      fontSize:20,
                      fontWeight:FontWeight.w600,
                    ),
                  ),

                  ElevatedButton.icon(

                    onPressed: () {
                      Navigator.pushNamed(context, "/add-product");
                    },

                    icon: const Icon(Icons.add, color: Colors.white),

                    label: const Text(
                      "Add Product",
                      style: TextStyle(color: Colors.white),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                    ),

                  )

                ],

              ),

              const SizedBox(height:20),

              tableHeader(),

              Expanded(

                child: SingleChildScrollView(

                  child: Column(

                    children: List.generate(
                      products.length,
                          (index){
                        return productRow(products[index]);
                      },
                    ),

                  ),

                ),

              )

            ],

          ),

        ),

      ),

    );

  }

}