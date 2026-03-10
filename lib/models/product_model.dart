class Product {

  final String barcode;
  final String prodName;
  final String category;
  final String manufacturer;
  final int expiryApplicable;

  Product({
    required this.barcode,
    required this.prodName,
    required this.category,
    required this.manufacturer,
    required this.expiryApplicable
  });

  factory Product.fromJson(Map<String,dynamic> json){

    return Product(
        barcode: json['barcode'],
        prodName: json['prod_name'],
        category: json['category'],
        manufacturer: json['manufacturer'] ?? "",
        expiryApplicable: json['expiry_applicable']
    );

  }

}