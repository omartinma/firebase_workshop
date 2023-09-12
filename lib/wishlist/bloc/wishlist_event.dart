part of 'wishlist_bloc.dart';

sealed class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object> get props => [];
}

class WishlistInitialized extends WishlistEvent {
  const WishlistInitialized();

  @override
  List<Object> get props => [];
}

class WishlistRequested extends WishlistEvent {
  const WishlistRequested({required this.product});

  final Product product;

  @override
  List<Object> get props => [product];
}
