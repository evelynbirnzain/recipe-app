import 'package:dad_2/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class _RecipeDetailsWidget extends StatelessWidget {
  final Recipe recipe;

  const _RecipeDetailsWidget(this.recipe);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SectionHeader(recipe.name, leading: Icon(Icons.restaurant)),
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
