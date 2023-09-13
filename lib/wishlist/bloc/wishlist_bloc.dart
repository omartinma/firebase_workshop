// ignore_for_file: avoid_print

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_workshop/global/global.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc(this._firebaseAuth, this._firestore)
      : super(const WishlistState()) {
    on<WishlistInitialized>(_initialized);
    on<WishlistRequested>(_requested);
  }

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  Future<FutureOr<void>> _initialized(
    WishlistInitialized event,
    Emitter<WishlistState> emit,
  ) async {
    final userId = _firebaseAuth.currentUser!.uid;
    await emit.forEach(
      _firestore
          .collection('wishlist/$userId/products')
          .withConverter<Product>(
            fromFirestore: (snapshot, _) => Product.fromMap(
              id: snapshot.id,
              map: snapshot.data()!,
            ),
            toFirestore: (model, _) => model.toMap(),
          )
          .snapshots(),
      onData: (data) {
        final products = data.docs.map((e) => e.data()).toList();
        return state.copyWith(products: products);
      },
      onError: (error, stackTrace) {
        print(error);
        return state;
      },
    );
  }

  FutureOr<void> _requested(
    WishlistRequested event,
    Emitter<WishlistState> emit,
  ) async {
    emit(state.copyWith(status: Status.adding));
    try {
      final userId = _firebaseAuth.currentUser!.uid;
      final doc = await _firestore
          .collection('wishlist/$userId/products')
          .doc(event.product.id)
          .get();
      if (doc.exists) {
        await _firestore
            .collection('wishlist/$userId/products')
            .doc(event.product.id)
            .delete();
        emit(state.copyWith(status: Status.deleted));
      } else {
        await _firestore
            .collection('wishlist/$userId/products')
            .doc(event.product.id)
            .set(event.product.toMap());
        emit(state.copyWith(status: Status.added));
      }
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        return emit(state.copyWith(status: Status.permissionError));
      }
      return emit(state.copyWith(status: Status.unknownError));
    }
  }
}
