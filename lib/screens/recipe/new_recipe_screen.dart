import 'package:dad_2/widgets/recipe/recipe_form.dart';
import 'package:dad_2/widgets/screen_wrapper/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/user_provider.dart';
import '../../widgets/util/section_header.dart';

class NewRecipeScreen extends ConsumerWidget {
  NewRecipeScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return ScreenWrapper(
      Column(children: [
        const SectionHeader("Add recipe", leading: Icon(Icons.add)),
        user.value == null
            ? const Center(child: Text('Please login first'))
            : RecipeFormWidget.add(),
      ]),
    );
  }
}
