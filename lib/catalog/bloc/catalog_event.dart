part of 'catalog_bloc.dart';

sealed class CatalogEvent extends Equatable {
  const CatalogEvent();

  @override
  List<Object> get props => [];
}

class CatalogCategoriesFetched extends CatalogEvent {
  const CatalogCategoriesFetched();

  @override
  List<Object> get props => [];
}

class CatalogProductsFetched extends CatalogEvent {
  const CatalogProductsFetched({required this.categoryId});

  final String categoryId;

  @override
  List<Object> get props => [categoryId];
}
