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
            categorySelected: const Category.all(),
          ),
        ) {
    on<CatalogFetched>(_fetched);
    on<CatalogCategorySelected>(_categorySelected);
    on<CatalogCategoriesFetched>(_categoriesFetched);
    on<CatalogProductByCategoryFetched>(_productByCategoryFetched);
  }

  final FirebaseFirestore _firestore;

  CollectionReference<Category> _getCategoriesRef() {
    return _firestore.collection('categories').withConverter<Category>(
          fromFirestore: (snapshot, options) =>
              Category.fromMap(snapshot.data() ?? {}),
          toFirestore: (value, options) => value.toMap(),
        );
  }

  CollectionReference<Product> _getProductsRef() {
    return _firestore.collection('products').withConverter<Product>(
          fromFirestore: (snapshot, options) =>
              Product.fromMap(snapshot.data() ?? {}),
          toFirestore: (value, options) => value.toMap(),
        );
  }

// Example 1 fetching all at once
  FutureOr<void> _fetched(
    CatalogFetched event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(catalogStatus: CatalogStatus.loadingCategories));
    final categoriesRef = _getCategoriesRef();
    final productsRef = _getProductsRef();
    final lastTimeDataFetched = state.lastTimeFetched ?? DateTime(1);
    final now = DateTime.now();
    final difference = now.difference(lastTimeDataFetched).inDays;
    QuerySnapshot<Category> categoriesSnapshot;
    QuerySnapshot<Product> productSnapshot;
    if (difference >= 1) {
      // Never fetched before -> we fetch from the server
      categoriesSnapshot = await categoriesRef.get();
      productSnapshot = await productsRef.get();
    } else {
      // Fetched less than a day ago -> we fetch from cache
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

  // Example 2 fetching products per category

  FutureOr<void> _categoriesFetched(
    CatalogCategoriesFetched event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(catalogStatus: CatalogStatus.loadingCategories));
    final categoriesRef = _getCategoriesRef();
    final categoriesSnapshot = await categoriesRef.get();
    final categories = categoriesSnapshot.docs.map((e) => e.data()).toList();
    emit(state.copyWith(categories: categories));
    add(const CatalogProductByCategoryFetched(category: Category.all()));
  }

  FutureOr<void> _productByCategoryFetched(
    CatalogProductByCategoryFetched event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(catalogStatus: CatalogStatus.loadingProducts));
    final productsRef = _getProductsRef();
    QuerySnapshot<Product> productSnapshot;
    if (event.category.name == 'all') {
      productSnapshot = await productsRef.get();
    } else {
      productSnapshot = await productsRef
          .where('categoryName', isEqualTo: event.category.name)
          .get();
    }
    final products = productSnapshot.docs.map((e) => e.data()).toList();
    emit(
      state.copyWith(
        products: products,
        catalogStatus: CatalogStatus.success,
        categorySelected: event.category,
      ),
    );
  }
}
