part of 'catalog_bloc.dart';

class CatalogState extends Equatable {
  const CatalogState({
    required this.categories,
  });

  final List<Category> categories;

  @override
  List<Object> get props => [categories];

  CatalogState copyWith({
    List<Category>? categories,
  }) {
    return CatalogState(
      categories: categories ?? this.categories,
    );
  }
}
