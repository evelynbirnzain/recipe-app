import 'dart:math';

import 'package:dad_2/providers/category_provider.dart';
import 'package:dad_2/widgets/util/card_with_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryPreview extends ConsumerWidget {

  final bool showAll;

  const CategoryPreview(this.showAll, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    final cnt = showAll ? categories.length : min(8, categories.length);
    final height = showAll ? 150.0 : 250.0;
    return SizedBox(
        height: height,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: cnt,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CardWithImage(
              category.name,
              '/recipes?categoryId=${category.id}',
            );
          },
        ));
  }
}
