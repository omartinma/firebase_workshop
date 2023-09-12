part of 'wishlist_bloc.dart';

enum Status { initial, adding, added, deleted }

class WishlistState extends Equatable {
  const WishlistState({
    this.products = const [],
    this.status = Status.initial,
  });

  final List<Product> products;
  final Status status;

  @override
  List<Object> get props => [products, status];

  WishlistState copyWith({
    List<Product>? products,
    Status? status,
  }) {
    return WishlistState(
      products: products ?? this.products,
      status: status ?? this.status,
    );
  }
}
