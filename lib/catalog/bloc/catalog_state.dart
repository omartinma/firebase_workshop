part of 'catalog_bloc.dart';

enum CatalogStatus {
  initial,
  loading,
  success,
}

class CatalogState extends Equatable {
  const CatalogState({
    required this.categories,
    required this.categorySelected,
    required this.products,
    this.catalogStatus = CatalogStatus.initial,
  });
  final CatalogStatus catalogStatus;
  final List<Category> categories;
  final Category categorySelected;
  final List<Product> products;

  List<Product> get productsFiltered {
    if (categorySelected.name == 'all') return products;
    return products
        .where((element) => element.categoryName == categorySelected.name)
        .toList();
  }

  @override
  List<Object> get props => [
        catalogStatus,
        categories,
        categorySelected,
        products,
      ];

  CatalogState copyWith({
    CatalogStatus? catalogStatus,
    List<Category>? categories,
    Category? categorySelected,
    List<Product>? products,
  }) {
    return CatalogState(
      catalogStatus: catalogStatus ?? this.catalogStatus,
      categories: categories ?? this.categories,
      categorySelected: categorySelected ?? this.categorySelected,
      products: products ?? this.products,
    );
  }
}
