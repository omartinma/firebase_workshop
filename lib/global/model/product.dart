import 'dart:convert';

import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    required this.name,
    required this.categoryName,
    required this.image,
    required this.description,
  });

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] as String,
      categoryName: map['categoryName'] as String,
      image: map['image'] as String,
      description: map['description'] as String,
    );
  }

  final String name;
  final String categoryName;
  final String image;
  final String description;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'categoryName': categoryName,
      'image': image,
      'description': description,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [name, categoryName, image, description];
}
