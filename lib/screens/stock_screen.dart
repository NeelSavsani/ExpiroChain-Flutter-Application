import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../widgets/app_layout.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {

  List stocks = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadStocks();
  }

  Future<void> loadStocks() async {
    try {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt("user_id") ?? 0;

      print("User ID: $userId");

      final result = await ApiService.getStocks(userId);

      print("API RESULT: $result");

      if (result["status"] == "success") {
        setState(() {
          stocks = List.from(result["stocks"] ?? []);
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }

    } catch (e) {
      print("ERROR: $e");
      setState(() {
        loading = false;
      });
    }
  }

  String formatDate(String date){
    if(date == "0000-00-00" || date.isEmpty){
      return "—";
    }

    DateTime parsed = DateTime.parse(date);
    return DateFormat("dd MMM yyyy").format(parsed);
  }

  /* TABLE HEADER */

  Widget tableHeader(){
    return Container(
      padding: const EdgeInsets.symmetric(vertical:12),
      color: const Color(0xFF0F172A),

      child: Row(
        children: const [

          SizedBox(
            width:160,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal:10),
              child: Text(
                "Product Name",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

          SizedBox(
            width:120,
            child: Text(
              "Batch No",
              style: TextStyle(color: Colors.white),
            ),
          ),

          SizedBox(
            width:100,
            child: Text(
              "Expiry",
              style: TextStyle(color: Colors.white),
            ),
          ),

          SizedBox(
            width:90,
            child: Text(
              "Quantity",
              style: TextStyle(color: Colors.white),
            ),
          ),

          SizedBox(
            width:140,
            child: Text(
              "Added At",
              style: TextStyle(color: Colors.white),
            ),
          ),

        ],
      ),
    );
  }

  /* STOCK ROW */

  Widget stockRow(stock){

    return Container(
      padding: const EdgeInsets.symmetric(vertical:14),

      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Color(0xFFE5E7EB))
        ),
      ),

      child: Row(
        children: [

          SizedBox(
            width:160,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:10),
              child: Text(
                stock["prod_name"].toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          SizedBox(
            width:120,
            child: Text(
              stock["batch_no"].toString(),
            ),
          ),

          SizedBox(
            width:100,
            child: Text(
              formatDate(stock["exp_date"].toString()),
            ),
          ),

          SizedBox(
            width:90,
            child: Text(
              stock["qty"].toString(),
            ),
          ),

          SizedBox(
            width:140,
            child: Text(
              stock["added_at"].toString(),
            ),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return AppLayout(

      route: "/stock",

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
                    "Stock",
                    style: TextStyle(
                        fontSize:20,
                        fontWeight:FontWeight.w600
                    ),
                  ),

                  ElevatedButton.icon(

                    onPressed: (){
                      Navigator.pushNamed(context, "/add-stock");
                    },

                    icon: const Icon(Icons.add),

                    label: const Text("Add Stock"),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                    ),

                  ),

                ],
              ),

              const SizedBox(height:20),

              /* SCROLLABLE TABLE */

              Expanded(

                child: SingleChildScrollView(

                  scrollDirection: Axis.horizontal,

                  child: SizedBox(

                    width:620,

                    child: Column(

                      children: [

                        tableHeader(),

                        Expanded(

                          child: ListView.builder(

                            itemCount: stocks.length,

                            itemBuilder: (context,index){
                              return stockRow(stocks[index]);
                            },

                          ),

                        ),

                      ],

                    ),

                  ),

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}