import 'package:dad_2/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../util/card_with_image.dart';

class CategoryListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final width = MediaQuery.of(context).size.width;

    var count = 5;
    if (width <= 300) {
      count = 2;
    } else if (width <= 800) {
      count = 3;
    }

    return Expanded(
        child: GridView.count(
            crossAxisCount: count,
            children: List.generate(categories.length, (index) {
              final category = categories[index];
              return CardWithImage(
                  category.name, '/recipes?categoryId=${category.id}');
            })));
  }
}
