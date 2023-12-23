import 'package:dad_2/widgets/recipe/recipe_form.dart';
import 'package:dad_2/widgets/screen_wrapper/screen_wrapper.dart';
import 'package:dad_2/widgets/util/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/recipe_provider.dart';
import '../../providers/user_provider.dart';

class EditRecipeScreen extends ConsumerWidget {
  final String id;

  const EditRecipeScreen(this.id, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final recipe = ref.watch(recipeProvider(id));

    if (recipe == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ScreenWrapper(Column(children: [
      const SectionHeader("Edit recipe", leading: Icon(Icons.edit)),
      user.value == null
          ? const Center(child: Text('Please login first'))
          : RecipeFormWidget.edit(recipe),
    ]));
  }
}
