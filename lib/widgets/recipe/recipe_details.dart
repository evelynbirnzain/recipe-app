import 'package:dad_2/widgets/util/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/recipe.dart';
import '../../providers/category_provider.dart';
import '../../providers/recipe_provider.dart';
import '../../providers/user_provider.dart';

class RecipeDetailsWidget extends ConsumerWidget {
  final String id;

  const RecipeDetailsWidget(this.id, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipe = ref.watch(recipeProvider(id));
    if (recipe == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return _RecipeDetailsWidget(recipe);
  }
}

class _RecipeDetailsWidget extends ConsumerWidget {
  final Recipe recipe;

  const _RecipeDetailsWidget(this.recipe);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final category = ref.watch(categoryProvider(recipe.category.id));

    if (category == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      children: [
        SectionHeader(recipe.name,
            leading: const Icon(Icons.restaurant),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (user.value?.uid == recipe.author)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => context.go('/recipes/${recipe.id}/edit'),
                  ),
                if (user.value?.uid == recipe.author)
                  IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        ref
                            .read(recipesProvider.notifier)
                            .deleteRecipe(recipe.id);
                        context.go('/');
                      }),
                if (user.value != null &&
                    !recipe.favorites.contains(user.value!.uid))
                  IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {
                        ref
                            .read(recipesProvider.notifier)
                            .toggleFavourite(recipe.id, user.value!.uid);
                      }),
                if (user.value != null &&
                    recipe.favorites.contains(user.value!.uid))
                  IconButton(
                      icon: const Icon(Icons.favorite),
                      onPressed: () {
                        ref
                            .read(recipesProvider.notifier)
                            .toggleFavourite(recipe.id, user.value!.uid);
                      }),
                Text('Favorited by ${recipe.favorites.length} user(s)')
              ],
            )),
        const Placeholder(),
        const SectionHeader('Category', leading: Icon(Icons.category)),
        ListTile(
          title: Text(category.name ?? 'Unknown'),
          onTap: () => context.go('/recipes?categoryId=${recipe.category.id}'),
        ),
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
