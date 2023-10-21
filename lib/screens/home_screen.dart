import 'package:dad_2/widgets/category_list.dart';
import 'package:dad_2/widgets/screen_wrapper.dart';
import 'package:dad_2/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/featured_recipe.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenWrapper(
      ListView(
        children: [
          const SectionHeader("Featured recipe", leading: Icon(Icons.star)),
          FeaturedRecipeWidget(),
          SectionHeader("Categories",
              leading: const Icon(Icons.category),
              trailing: ElevatedButton(
                  onPressed: () => context.go('/categories'),
                  child: const Text('Show all categories'))),
          CategoryListWidget(),
        ],
      ),
    );
  }
} // Expanded(child: CategoriesPreview())
