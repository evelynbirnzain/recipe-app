import 'package:dad_2/widgets/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/navigation_provider.dart';
import '../widgets/recipe_details.dart';

class RecipeScreen extends ConsumerWidget {
  final String id;

  RecipeScreen(this.id);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenWrapper(
      RecipeDetailsWidget(id),
    );
  }
}


