import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../models/recipe.dart';
import '../../providers/recipe_provider.dart';
import '../../providers/user_provider.dart';
import '../util/card_with_image.dart';

class RecipeListWidget extends ConsumerWidget {
  final String? categoryId;
  final String? search;
  final bool favourites;
  final String? uid;

  RecipeListWidget(this.categoryId, this.search, this.favourites,[this.uid]);

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
                        .toggle(recipe.id, user.value!.uid);
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
                      .toggle(recipe.id, user.value!.uid);
                }),
            Text(recipe.favorites.length.toString())
          ],
        ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    var count = 5;
    if (width <= 300) {
      count = 2;
    } else if (width <= 800) {
      count = 3;
    }

    final notifier = ref.watch(recipesProvider.notifier);
    if (categoryId != null) {
      notifier.setFilter(categoryId!, '', false, uid);
    } else if (search != null) {
      notifier.setFilter('', search!, false, uid);
    } else if (favourites) {
      notifier.setFilter('', '', true, uid);
    } else {
      notifier.setFilter('', '', false, uid);
    }

    final pagingController =
        ref.watch(recipesProvider.notifier).pagingController;

    return Expanded(
        child: PagedGridView<int, Recipe>(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: count),
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
