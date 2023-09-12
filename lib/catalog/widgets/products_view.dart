import 'package:firebase_workshop/global/global.dart';
import 'package:firebase_workshop/wishlist/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({required this.products, super.key});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SliverList.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey.shade500,
            ),
            height: 100,
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        product.name,
                        style: textTheme.headlineSmall,
                      ),
                      Text(
                        product.description,
                        style: textTheme.bodyMedium,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BlocBuilder<WishlistBloc, WishlistState>(
                            builder: (context, state) {
                              return IconButton(
                                onPressed: () {
                                  context.read<WishlistBloc>().add(
                                        WishlistRequested(
                                          product: product,
                                        ),
                                      );
                                },
                                icon: Icon(
                                  state.products.contains(product)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
