import 'dart:convert';

import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    required this.name,
    required this.categoryName,
    required this.image,
    required this.description,
    required this.id,
  });

  factory Product.fromMap({
    required Map<String, dynamic> map,
    required String id,
  }) {
    return Product(
      name: map['name'] as String,
      categoryName: map['categoryName'] as String,
      image: map['image'] as String,
      description: map['description'] as String,
      id: id,
    );
  }

  final String name;
  final String categoryName;
  final String image;
  final String description;
  final String id;

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
  List<Object?> get props => [name, categoryName, image, description, id];
}
