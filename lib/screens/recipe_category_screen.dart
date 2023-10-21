import 'package:dad_2/widgets/category_list.dart';
import 'package:dad_2/widgets/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/section_header.dart';

class RecipeCategoryScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenWrapper(
      Column(
        children: [
          const SectionHeader("Categories", leading: Icon(Icons.category)),
          CategoryListWidget(),
        ],
      ),
    );
  }
}
