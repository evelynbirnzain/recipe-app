import 'package:dad_2/breakpoints.dart';
import 'package:dad_2/widgets/screen_wrapper/screen_wrapper.dart';
import 'package:dad_2/widgets/util/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/category_provider.dart';
import '../../widgets/category/category_preview.dart';
import '../../widgets/recipe/recipe_list.dart';

class RecipeListScreen extends ConsumerWidget {
  final String? categoryId;
  final String? search;
  final bool favourites;

  const RecipeListScreen(this.categoryId, this.search, this.favourites, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String title;
    if (categoryId != null) {
      final category = ref.watch(categoryProvider(categoryId!));
      title = 'Recipes in category "${category?.name}"';
    } else if (search != null) {
      title = 'Recipes starting with "$search"';
    } else if (favourites) {
      title = 'My favourite recipes';
    } else {
      title = 'All recipes';
    }

    final width = MediaQuery.of(context).size.width;

    if (width <= Breakpoints.sm) {
      return ScreenWrapper(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title, leading: const Icon(Icons.restaurant)),
          RecipeListWidget(categoryId, search, favourites, ncols: 1),
        ],
      ));
    }

    if (width <= Breakpoints.lg) {
      return ScreenWrapper(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title, leading: const Icon(Icons.restaurant)),
          RecipeListWidget(categoryId, search, favourites, ncols: 3),
        ],
      ));
    }

    print("$width, ${Breakpoints.lg}, $categoryId");
    if (width > Breakpoints.lg && categoryId != null) {
      return ScreenWrapper(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader("Categories", leading: Icon(Icons.category)),
          const CategoryPreview(true),
          SectionHeader(title, leading: const Icon(Icons.restaurant)),
          RecipeListWidget(categoryId, search, favourites, ncols: 5),
        ],
      ));
    }

    return ScreenWrapper(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title, leading: const Icon(Icons.restaurant)),
        RecipeListWidget(categoryId, search, favourites, ncols: 5),
      ],
    ));
  }
}
