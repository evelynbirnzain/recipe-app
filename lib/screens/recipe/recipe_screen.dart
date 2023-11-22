import 'package:dad_2/widgets/screen_wrapper/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/recipe/recipe_details.dart';

class RecipeDetailsScreen extends ConsumerWidget {
  final String id;

  RecipeDetailsScreen(this.id);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenWrapper(
      RecipeDetailsWidget(id),
    );
  }
}
