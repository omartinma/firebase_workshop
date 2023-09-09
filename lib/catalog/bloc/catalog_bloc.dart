import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_workshop/global/global.dart';

part 'catalog_event.dart';
part 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  CatalogBloc(this._firestore)
      : super(
          CatalogState(
            categories: List.empty(),
            products: List.empty(),
            categorySelected: Category(name: 'all'),
          ),
        ) {
    on<CatalogFetched>(_categoriesFetched);
    on<CatalogCategorySelected>(_categorySelected);
  }

  final FirebaseFirestore _firestore;

  FutureOr<void> _categoriesFetched(
    CatalogFetched event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(catalogStatus: CatalogStatus.loading));
    final categoriesRef =
        _firestore.collection('categories').withConverter<Category>(
              fromFirestore: (snapshot, options) =>
                  Category.fromMap(snapshot.data() ?? {}),
              toFirestore: (value, options) => value.toMap(),
            );
    final productsRef =
        _firestore.collection('products').withConverter<Product>(
              fromFirestore: (snapshot, options) =>
                  Product.fromMap(snapshot.data() ?? {}),
              toFirestore: (value, options) => value.toMap(),
            );
    final lastTimeDataFetched = state.lastTimeFetched ?? DateTime(1);
    final now = DateTime.now();
    final difference = now.difference(lastTimeDataFetched).inDays;
    QuerySnapshot<Category> categoriesSnapshot;
    QuerySnapshot<Product> productSnapshot;
    if (difference >= 1) {
      categoriesSnapshot = await categoriesRef.get();
      productSnapshot = await productsRef.get();
    } else {
      categoriesSnapshot =
          await categoriesRef.get(const GetOptions(source: Source.cache));
      productSnapshot =
          await productsRef.get(const GetOptions(source: Source.cache));
    }
    final categories = categoriesSnapshot.docs.map((e) => e.data()).toList();
    final products = productSnapshot.docs.map((e) => e.data()).toList();

    emit(
      state.copyWith(
        categories: categories,
        products: products,
        catalogStatus: CatalogStatus.success,
        lastTimeFetched: now,
      ),
    );
  }

  FutureOr<void> _categorySelected(
    CatalogCategorySelected event,
    Emitter<CatalogState> emit,
  ) {
    emit(state.copyWith(categorySelected: event.category));
  }
}
