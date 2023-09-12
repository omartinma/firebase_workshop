import 'package:equatable/equatable.dart';

class Category extends Equatable {
  const Category({
    required this.name,
  });

  const Category.all() : this(name: 'all');
  const Category.white() : this(name: 'white');
  const Category.red() : this(name: 'red');

  final String name;

  @override
  List<Object?> get props => [name];

  Category copyWith({
    String? name,
    DateTime? lastTimeFetched,
  }) {
    return Category(
      name: name ?? this.name,
    );
  }
}
