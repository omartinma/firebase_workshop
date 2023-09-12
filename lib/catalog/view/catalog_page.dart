import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_workshop/catalog/catalog.dart';
import 'package:firebase_workshop/global/model/model.dart';
import 'package:firebase_workshop/wishlist/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const CatalogPage());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CatalogBloc(
            FirebaseFirestore.instance,
          )..add(
              const CatalogProductByCategoryFetched(category: Category.all()),
            ),
        ),
        BlocProvider(
          create: (context) => WishlistBloc(
            FirebaseAuth.instance,
            FirebaseFirestore.instance,
          )..add(const WishlistInitialized()),
        ),
      ],
      child: const CatalogView(),
    );
  }
}

class CatalogView extends StatelessWidget {
  const CatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<WishlistBloc, WishlistState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == Status.added) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Added to wishlist')),
            );
        } else if (state.status == Status.deleted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Deleted from wishlist')),
            );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wine Shop'),
        ),
        body: BlocBuilder<CatalogBloc, CatalogState>(
          builder: (context, state) {
            final categories = state.categories;
            final categorySelected = state.categorySelected;
            final products = state.products;
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: CategoriesFilter(
                    categories: categories,
                    categorySelected: categorySelected,
                  ),
                ),
                BlocBuilder<CatalogBloc, CatalogState>(
                  builder: (context, state) {
                    if (state.catalogStatus == CatalogStatus.loadingProducts) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (products.isNotEmpty) {
                      return ProductsView(products: products);
                    } else {
                      return const SliverToBoxAdapter(
                        child: Text(
                          'Sorry no data for this category',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
