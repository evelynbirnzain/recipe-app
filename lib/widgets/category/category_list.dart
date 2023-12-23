import 'package:dad_2/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../models/category.dart';
import '../util/card_with_image.dart';

class CategoryListWidget extends ConsumerWidget {

  final int ncols;

  const CategoryListWidget(this.ncols, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final pagingController =
        ref.read(categoriesProvider.notifier).pagingController;

    if (ncols == 1) {
      return Expanded(
          child: PagedListView<int, Category>(
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<Category>(
          itemBuilder: (context, category, index) {
            return ListTile(
              title: Text(category.name),
              onTap: () => context.go('/recipes?categoryId=${category.id}'),
            );
          },
        ),
      ));
    }

    return Expanded(
        child: PagedGridView<int, Category>(
      pagingController: pagingController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ncols,
        childAspectRatio: 1,
      ),
      builderDelegate: PagedChildBuilderDelegate<Category>(
        itemBuilder: (context, category, index) {
          return CardWithImage(
            category.name,
            '/recipes?categoryId=${category.id}',
          );
        },
      ),
    ));
  }
}
