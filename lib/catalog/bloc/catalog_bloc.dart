import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_workshop/global/global.dart';

part 'catalog_event.dart';
part 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  CatalogBloc(this._firestore) : super(CatalogState(categories: List.empty())) {
    on<CatalogCategoriesFetched>(_categoriesFetched);
  }

  final FirebaseFirestore _firestore;

  FutureOr<void> _categoriesFetched(
    CatalogCategoriesFetched event,
    Emitter<CatalogState> emit,
  ) async {
    final categoriesSnapshot =
        _firestore.collection('categories').withConverter<Category>(
              fromFirestore: (snapshot, options) =>
                  Category.fromMap(snapshot.data() ?? {}),
              toFirestore: (value, options) => value.toMap(),
            );
    await emit.forEach(
      categoriesSnapshot.snapshots(),
      onData: (data) {
        final categories = data.docs.map((e) => e.data()).toList();
        return state.copyWith(categories: categories);
      },
    );
  }
}
