import 'package:dad_2/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CategoryListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    return Container(
        height: 250,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return SizedBox(
                width: 250,
                child: Card(
                  margin: const EdgeInsets.all(10),
                  child: Column(children: [
                    Expanded(
                        child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 100),
                            child: const Placeholder())),
                    ListTile(
                      title: Text(category.name),
                      onTap: () =>
                          context.go('/recipes?categoryId=${category.id}'),
                    ),
                  ]),
                ));
          },
        ));
  }
}
