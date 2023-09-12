// ignore_for_file: avoid_print

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_workshop/global/global.dart';
import 'package:http/http.dart' as http;

part 'catalog_event.dart';
part 'catalog_state.dart';

const _categories = [
  Category.all(),
  Category.white(),
  Category.red(),
];

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  CatalogBloc(this._firestore)
      : super(
          CatalogState(
            categories: _categories,
            products: List.empty(),
            categorySelected: _categories.first,
            // We should keep this data in local storage
            lastTimeFetched: Map<Category, DateTime>.fromIterable(
              _categories,
              value: (e) => DateTime(1),
            ),
          ),
        ) {
    on<CatalogProductByCategoryFetched>(_productByCategoryFetched);
  }

  final FirebaseFirestore _firestore;

  CollectionReference<Product> _getProductsRef() {
    return _firestore.collection('products').withConverter<Product>(
          fromFirestore: (snapshot, options) =>
              Product.fromMap(snapshot.data() ?? {}),
          toFirestore: (value, options) => value.toMap(),
        );
  }

  Future<bool> _loadBundle() async {
    try {
      final res = await http.get(
        Uri.parse(
          'https://us-central1-fir-workshop-8801d.cloudfunctions.net/ext-firestore-bundle-builder-serve/products',
        ),
      );
      final task = _firestore.loadBundle(res.bodyBytes);
      await task.stream.first;
      print('bundle loaded');
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  (bool, DateTime) _shouldLoadFromServer(Category category) {
    final lastTimeFetched = state.lastTimeFetched[category];
    final now = DateTime.now();
    final difference = now.difference(lastTimeFetched!).inDays;
    return (difference >= 1, now);
  }

  FutureOr<void> _productByCategoryFetched(
    CatalogProductByCategoryFetched event,
    Emitter<CatalogState> emit,
  ) async {
    final shouldLoadBundle = state.shouldLoadBundle;
    emit(state.copyWith(catalogStatus: CatalogStatus.loadingProducts));

    // Loading bundle
    if (shouldLoadBundle) {
      final isLoaded = await _loadBundle();
      if (isLoaded) {
        emit(
          state.copyWith(
            lastTimeFetched: Map<Category, DateTime>.fromIterable(
              _categories,
              value: (e) => DateTime.now(),
            ),
          ),
        );
      }
    }

    // Querying products from server or cache
    final productsRef = _getProductsRef();
    QuerySnapshot<Product> productSnapshot;
    final shouldLoadFromServer = _shouldLoadFromServer(event.category);
    final options = GetOptions(
      source: shouldLoadFromServer.$1 ? Source.serverAndCache : Source.cache,
    );
    if (event.category == const Category.all()) {
      productSnapshot = await productsRef.get(options);
    } else {
      productSnapshot = await productsRef
          .where('categoryName', isEqualTo: event.category.name)
          .get(options);
    }
    final products = productSnapshot.docs.map((e) => e.data()).toList();
    Map<Category, DateTime> lastTimeFetched;
    if (shouldLoadFromServer.$1) {
      print('Loaded from server');
      lastTimeFetched = {
        ...state.lastTimeFetched,
        event.category: shouldLoadFromServer.$2,
      };
    } else {
      print('Loaded from cache');
      lastTimeFetched = state.lastTimeFetched;
    }

    emit(
      state.copyWith(
        products: products,
        catalogStatus: CatalogStatus.success,
        categorySelected: event.category,
        lastTimeFetched: lastTimeFetched,
      ),
    );
  }
}
