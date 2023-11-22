import 'package:dad_2/widgets/recipe_form.dart';
import 'package:dad_2/widgets/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewRecipeScreen extends ConsumerWidget {
  NewRecipeScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenWrapper(
       RecipeFormWidget.add(),
    );
  }
}


