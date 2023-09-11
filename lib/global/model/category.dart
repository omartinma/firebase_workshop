import 'dart:convert';

import 'package:equatable/equatable.dart';

class Category extends Equatable {
  const Category({
    required this.name,
  });

  const Category.all() : this(name: 'all');

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'] as String,
    );
  }

  final String name;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [name];
}
