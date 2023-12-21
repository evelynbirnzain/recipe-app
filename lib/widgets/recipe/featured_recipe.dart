import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/recipe.dart';
import '../../providers/category_provider.dart';
import '../../providers/recipe_provider.dart';

class FeaturedRecipeWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipe = ref.watch(featuredRecipeProvider);

    if (recipe == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return _desktopLayout(recipe, context, ref);
        } else {
          return _phoneLayout(recipe, context);
        }
      },
    );
  }

  Widget _phoneLayout(Recipe recipe, BuildContext context) {
    return Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: InkWell(
          onTap: () => context.go('/recipes/${recipe.id}'),
          child: Column(children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: const Placeholder(),
              ),
            ),
            ListTile(
              title: Text(recipe.name),
              titleTextStyle: const TextStyle(fontSize: 20),
            ),
          ]),
        ));
  }

  Widget _desktopLayout(Recipe recipe, BuildContext context, WidgetRef ref) {
    final category = ref.watch(categoryProvider(recipe.category.id));

    if (category == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: InkWell(
          onTap: () => context.go('/recipes/${recipe.id}'),
          child: Row(children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: const Placeholder(),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const ListTile(
                    title: Text("Try this recipe today!"),
                  ),
                  ListTile(
                    title: Text(recipe.name),
                    titleTextStyle: const TextStyle(fontSize: 24),
                  ),
                  ListTile(
                      title: Text("Category: ${category?.name}"),

                      ),
                ],
              ),
            ),
          ]),
        ));
  }
}
