import 'package:flutter/material.dart';
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
        setState(() { loading = false; });
        return;
      }

      final result = await ApiService.getProducts(userId);

      if(result["status"] == "success"){
        setState(() {
          products = List.from(result["products"]);
          loading = false;
        });
      }
      else{
        setState(() { loading = false; });
      }

    } catch(e) {
      print("ERROR: $e");
      setState(() { loading = false; });
    }
  }

  /* EXPIRY ICON */

  Widget expiryIcon(int value){

    if(value == 1){
      return const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 20,
      );
    }

    return const Icon(
      Icons.cancel,
      color: Colors.red,
      size: 20,
    );
  }

  /* TABLE HEADER */

  Widget tableHeader(){

    return Container(
      padding: const EdgeInsets.symmetric(vertical:12),
      color: const Color(0xFF0F172A),

      child: const Row(
        children: [

          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal:10),
              child: Text(
                "Product Name",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              "Category",
              style: TextStyle(color: Colors.white),
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              "Manufacturer",
              style: TextStyle(color: Colors.white),
            ),
          ),

          Expanded(
            flex: 1,
            child: Text(
              "Expiry",
              style: TextStyle(color: Colors.white),
            ),
          ),

        ],
      ),
    );
  }

  /* PRODUCT ROW */

  Widget productRow(product){

    return Container(
      padding: const EdgeInsets.symmetric(vertical:14),

      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),

      child: Row(
        children: [

          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:10),
              child: Text(
                product["prod_name"].toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              product["category"],
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              product["manufacturer"] ?? "—",
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Expanded(
            flex: 1,
            child: expiryIcon(
              int.parse(product["expiry_applicable"].toString()),
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
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
              )
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

                    onPressed: (){
                      Navigator.pushNamed(context, "/add-product");
                    },

                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),

                    label: const Text(
                      "Add Product",
                      style: TextStyle(color: Colors.white),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                    ),

                  ),

                ],
              ),

              const SizedBox(height:20),

              /* TABLE */

              Expanded(

                child: SingleChildScrollView(

                  scrollDirection: Axis.horizontal,

                  child: SizedBox(

                    width: MediaQuery.of(context).size.width,

                    child: Column(

                      children: [

                        tableHeader(),

                        Expanded(
                          child: ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (context,index){
                              return productRow(products[index]);
                            },
                          ),
                        )

                      ],
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