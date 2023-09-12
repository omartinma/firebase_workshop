part of 'catalog_bloc.dart';

sealed class CatalogEvent extends Equatable {
  const CatalogEvent();

  @override
  List<Object> get props => [];
}

class CatalogProductByCategoryFetched extends CatalogEvent {
  const CatalogProductByCategoryFetched({required this.category});

  final Category category;

  @override
  List<Object> get props => [category];
}
