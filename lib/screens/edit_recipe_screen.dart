import 'package:dad_2/widgets/recipe_form.dart';
import 'package:dad_2/widgets/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/recipe_provider.dart';

class EditRecipeScreen extends ConsumerWidget {
  final String id;

  EditRecipeScreen(this.id);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipe = ref.watch(recipeProvider(id));
    return ScreenWrapper(
      RecipeFormWidget.edit(recipe),
    );
  }
}
