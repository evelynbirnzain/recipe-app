import 'package:dad_2/widgets/screen_wrapper/screen_wrapper.dart';
import 'package:dad_2/widgets/util/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/category_provider.dart';
import '../../widgets/recipe/recipe_list.dart';

class RecipeListScreen extends ConsumerWidget {
  final String? categoryId;
  final String? search;

  RecipeListScreen(this.categoryId, this.search);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var title;
    if (categoryId != null) {
      final category = ref.watch(categoryProvider(categoryId!));
      title = 'Recipes in category "${category?.name}"';
    } else if (search != null) {
      title = 'Recipes starting with "$search"';
    } else {
      title = 'All recipes';
    }

    return ScreenWrapper(Column(
      children: [
        SectionHeader(title, leading: Icon(Icons.restaurant)),
        RecipeListWidget(categoryId, search, false),
      ],
    ));
  }
}
