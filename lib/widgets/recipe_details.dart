import 'package:dad_2/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/recipe.dart';
import '../providers/recipe_provider.dart';

class RecipeDetailsWidget extends ConsumerWidget {
  final String id;

  RecipeDetailsWidget(this.id);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      final recipe = ref.watch(recipeProvider(id));
      return _RecipeDetailsWidget(recipe);
    } catch (e) {
      return const Center(child: CircularProgressIndicator());
    }
  }
}

class _RecipeDetailsWidget extends ConsumerWidget {
  final Recipe recipe;

  const _RecipeDetailsWidget(this.recipe);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        SectionHeader(recipe.name, leading: Icon(Icons.restaurant), trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => context.go('/recipes/${recipe.id}/edit'),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                ref.read(recipesProvider.notifier).deleteRecipe(recipe.id);
                context.go('/recipes');
              }
            ),
          ],
        )),
        const Placeholder(),
        const SectionHeader('Ingredients', leading: Icon(Icons.shopping_cart)),
        ListView.builder(
          shrinkWrap: true,
          itemCount: recipe.ingredients.length,
          itemBuilder: (context, index) {
            final ingredient = recipe.ingredients[index];
            return Card(
                child: ListTile(
              title: Text(ingredient),
            ));
          },
        ),
        const SectionHeader('Steps', leading: Icon(Icons.list)),
        ListView.builder(
            shrinkWrap: true,
            itemCount: recipe.steps.length,
            itemBuilder: (context, index) {
              final step = recipe.steps[index];
              return Card(
                  child: ListTile(
                title: Text(step),
                leading: Text('${index + 1}'),
              ));
            })
      ],
    );
  }
}
