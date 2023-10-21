import 'package:dad_2/widgets/screen_wrapper.dart';
import 'package:dad_2/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/navigation_provider.dart';
import '../widgets/recipe_list.dart';

class RecipeListScreen extends ConsumerWidget {
  final String? categoryId;
  final String? search;

  RecipeListScreen(this.categoryId, this.search);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenWrapper(Column(
      children: [
        SectionHeader("Recipes", leading: const Icon(Icons.restaurant)),
        RecipeListWidget(categoryId, search),
      ],
    ));
  }
}
