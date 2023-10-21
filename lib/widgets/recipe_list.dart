import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/recipe_provider.dart';

class RecipeListWidget extends ConsumerWidget {
  final String? categoryId;
  final String? search;

  RecipeListWidget(this.categoryId, this.search);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var recipes = ref.watch(recipesProvider);
    if (categoryId != null) {
      recipes = recipes.where((r) => r.category.id == categoryId).toList();
    }
    if (search != null) {
      recipes = recipes
          .where((r) =>
              r.name.toLowerCase().contains(search!.toLowerCase()))
          .toList();
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return Card(
          child: ListTile(
            title: Text(recipe.name),
            onTap: () => context.go('/recipes/${recipe.id}'),
          ),
        );
      },
    );
  }
}
