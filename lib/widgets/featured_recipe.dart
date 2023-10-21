import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';

import '../providers/recipe_provider.dart';

class FeaturedRecipeWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(recipesProvider);
    if (recipes.isEmpty) return Container();
    final recipe = recipes[Random().nextInt(recipes.length)];

    return Card(
        child: Column(children: [
      ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 300),
          child: const Placeholder()),
      ListTile(
          title: Text(recipe.name),
          onTap: () => context.go('/recipes/${recipe.id}')),
    ]));
  }
}
