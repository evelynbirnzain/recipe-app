import 'package:dad_2/widgets/screen_wrapper/screen_wrapper.dart';
import 'package:dad_2/widgets/util/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/user_provider.dart';
import '../../widgets/recipe/recipe_list.dart';

class FavouriteRecipesScreen extends ConsumerWidget {
  FavouriteRecipesScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return ScreenWrapper(Column(
      children: [
        SectionHeader("My Favourite Recipes", leading: const Icon(Icons.restaurant)),
        RecipeListWidget(null, null, true, user.value?.uid),
      ],
    ));
  }
}
