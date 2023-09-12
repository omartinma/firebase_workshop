import 'package:firebase_workshop/catalog/catalog.dart';
import 'package:firebase_workshop/global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
