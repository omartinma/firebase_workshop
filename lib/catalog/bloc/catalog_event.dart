part of 'catalog_bloc.dart';

sealed class CatalogEvent extends Equatable {
  const CatalogEvent();

  @override
  List<Object> get props => [];
}

class CatalogFetched extends CatalogEvent {
  const CatalogFetched();

  @override
  List<Object> get props => [];
}
