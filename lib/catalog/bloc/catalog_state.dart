part of 'catalog_bloc.dart';

enum CatalogStatus {
  initial,
  loadingProducts,
  success,
}

class CatalogState extends Equatable {
  const CatalogState({
    required this.categories,
    required this.categorySelected,
    required this.products,
    required this.lastTimeFetched,
    this.catalogStatus = CatalogStatus.initial,
  });

  final CatalogStatus catalogStatus;
  final List<Category> categories;
  final Map<Category, DateTime> lastTimeFetched;
  final Category categorySelected;
  final List<Product> products;

  bool get shouldLoadBundle => catalogStatus == CatalogStatus.initial;

  @override
  List<Object?> get props => [
        catalogStatus,
        categories,
        categorySelected,
        products,
        lastTimeFetched,
      ];

  CatalogState copyWith({
    CatalogStatus? catalogStatus,
    List<Category>? categories,
    Map<Category, DateTime>? lastTimeFetched,
    Category? categorySelected,
    List<Product>? products,
  }) {
    return CatalogState(
      catalogStatus: catalogStatus ?? this.catalogStatus,
      categories: categories ?? this.categories,
      lastTimeFetched: lastTimeFetched ?? this.lastTimeFetched,
      categorySelected: categorySelected ?? this.categorySelected,
      products: products ?? this.products,
    );
  }
}
