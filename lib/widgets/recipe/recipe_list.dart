import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../models/recipe.dart';
import '../../providers/recipe_provider.dart';
import '../../providers/user_provider.dart';
import '../util/card_with_image.dart';

class RecipeListWidget extends ConsumerWidget {
  final String? categoryId;
  final String? search;
  final bool favourites;
  final int ncols;

  const RecipeListWidget(this.categoryId, this.search, this.favourites, {super.key, this.ncols = 2});

  Widget? buildFavouriteButton(
      BuildContext context, Recipe recipe, WidgetRef ref) {
    final user = ref.watch(userProvider);
    if (user.value == null) {
      return null;
    }

    if (!recipe.favorites.contains(user.value!.uid)) {
      return SizedBox(
          width: 47,
          child: Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {
                    ref
                        .read(recipesProvider.notifier)
                        .toggleFavourite(recipe.id, user.value!.uid);
                  }),
              Text(recipe.favorites.length.toString())
            ],
          ));
    }

    return SizedBox(
        width: 47,
        child: Row(
          children: [
            IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  ref
                      .read(recipesProvider.notifier)
                      .toggleFavourite(recipe.id, user.value!.uid);
                }),
            Text(recipe.favorites.length.toString())
          ],
        ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(userProvider).value?.uid;
    final notifier = ref.read(recipesProvider.notifier);
    notifier.setFilter(categoryId ?? '', search ?? '', favourites, uid);
    final pagingController = notifier.pagingController;

    if (favourites && uid == null) {
      return const Text('Please log in first to see your favourite recipes');
    }

    print('ncols: $ncols');

    if (ncols == 1) {
      return Expanded(
          child: PagedListView<int, Recipe>(
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<Recipe>(
            itemBuilder: (context, recipe, index) => ListTile(
                  title: Text(recipe.name),
                  onTap: () => context.go('/recipes/${recipe.id}'),
                  trailing: buildFavouriteButton(context, recipe, ref),
                )),
      ));
    }

    return Expanded(
        child: PagedGridView<int, Recipe>(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: ncols),
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate<Recipe>(
          itemBuilder: (context, recipe, index) => CardWithImage(
                recipe.name,
                '/recipes/${recipe.id}',
                buildFavouriteButton(context, recipe, ref),
              )),
    ));
  }
}
