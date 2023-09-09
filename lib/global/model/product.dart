import 'dart:convert';

import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    required this.name,
    required this.categoryName,
    required this.image,
  });

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] as String,
      categoryName: map['categoryName'] as String,
      image: map['image'] as String,
    );
  }

  final String name;
  final String categoryName;
  final String image;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'categoryName': categoryName,
      'image': image,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [name, categoryName, image];
}
