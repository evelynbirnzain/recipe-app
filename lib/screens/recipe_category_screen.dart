import 'package:dad_2/breakpoints.dart';
import 'package:dad_2/widgets/category/category_list.dart';
import 'package:dad_2/widgets/screen_wrapper/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/util/section_header.dart';

class RecipeCategoryScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;

    if (width <= Breakpoints.sm) {
      return ScreenWrapper(
        Column(
          children: [
            const SectionHeader("Categories", leading: Icon(Icons.category)),
            CategoryListWidget(1),
          ],
        ),
      );
    }

    if (width <= Breakpoints.md) {
      return ScreenWrapper(
        Column(
          children: [
            const SectionHeader("Categories", leading: Icon(Icons.category)),
            CategoryListWidget(2),
          ],
        ),
      );
    }

    if (width <= Breakpoints.lg) {
      return ScreenWrapper(
        Column(
          children: [
            const SectionHeader("Categories", leading: Icon(Icons.category)),
            CategoryListWidget(3),
          ],
        ),
      );
    }

    return ScreenWrapper(
      Column(
        children: [
          const SectionHeader("Categories", leading: Icon(Icons.category)),
          CategoryListWidget(5),
        ],
      ),
    );
  }
}
