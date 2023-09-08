import 'dart:convert';

class Product {
  Product({
    required this.name,
    required this.categoryName,
  });

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] as String,
      categoryName: map['categoryName'] as String,
    );
  }

  final String name;
  final String categoryName;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'categoryName': categoryName,
    };
  }

  String toJson() => json.encode(toMap());
}
