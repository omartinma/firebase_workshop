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
      create: (context) => CatalogBloc(FirebaseFirestore.instance)
        ..add(const CatalogProductByCategoryFetched(category: Category.all())),
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
              state.catalogStatus == CatalogStatus.loadingCategories) {
            return const Center(child: CircularProgressIndicator());
          }
          final categories = state.categories;
          final categorySelected = state.categorySelected;
          final productFiltered = state.products;
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
                  } else if (productFiltered.isNotEmpty) {
                    return ProductsView(products: productFiltered);
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
    );
  }
}

class CategoriesFilter extends StatelessWidget {
  const CategoriesFilter({
    required this.categories,
    required this.categorySelected,
    super.key,
  });

  final List<Category> categories;
  final Category categorySelected;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
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
                context.read<CatalogBloc>().add(
                      CatalogProductByCategoryFetched(category: category),
                    );
              },
              child: Container(
                height: 30,
                width: 100,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: category == categorySelected
                        ? Colors.amber
                        : primaryColor,
                    width: 3,
                  ),
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
