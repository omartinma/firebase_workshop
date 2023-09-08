import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_workshop/catalog/catalog.dart';
import 'package:firebase_workshop/global/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const CatalogPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CatalogBloc(FirebaseFirestore.instance)..add(const CatalogFetched()),
      child: const CatalogView(),
    );
  }
}

class CatalogView extends StatelessWidget {
  const CatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wine Shop'),
      ),
      body: BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, state) {
          if (state.catalogStatus == CatalogStatus.initial ||
              state.catalogStatus == CatalogStatus.loading) {
            return const CircularProgressIndicator();
          }
          final categories = state.categories;
          final productFiltered = state.productsFiltered;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: CategoriesFilter(categories: categories),
              ),
              ProductsView(products: productFiltered),
            ],
          );
        },
      ),
    );
  }
}

class CategoriesFilter extends StatelessWidget {
  const CategoriesFilter({required this.categories, super.key});

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                context
                    .read<CatalogBloc>()
                    .add(CatalogCategorySelected(category: category));
              },
              child: Container(
                height: 30,
                width: 100,
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      category.name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

class ProductsView extends StatelessWidget {
  const ProductsView({required this.products, super.key});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Container(
          color: Colors.blue,
          alignment: Alignment.center,
          width: 100,
          height: 100,
          child: Text(product.name),
        );
      },
    );
  }
}
