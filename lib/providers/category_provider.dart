import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dad_2/models/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CategoryNotifier extends StateNotifier<List<Category>> {
  CategoryNotifier() : super([]) {
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    _fetchCategories();
  }

  final pageSize = 20;
  final pagingController = PagingController<int, Category>(firstPageKey: 0);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _fetchCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    final categories = snapshot.docs.map((doc) {
      return Category.fromFirestore(doc.data(), doc.id);
    }).toList();

    state = categories;
  }

  void _fetchPage(int pageKey) async {
    try {
      Query<Map<String, dynamic>> query = _firestore.collection('categories');

      query = query.orderBy('name').limit(pageSize);
      QuerySnapshot<Map<String, dynamic>> snapshot;
      if (pageKey == 0) {
        snapshot = await query.get();
      } else {
        final last = pagingController.itemList!.last;
        snapshot = await query.startAfter([last.name]).get();
      }

      final categories = snapshot.docs.map((doc) {
        return Category.fromFirestore(doc.data(), doc.id);
      }).toList();

      final isLastPage = categories.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(categories);
      } else {
        final nextPageKey = pageKey + categories.length;
        pagingController.appendPage(categories, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }
}

final categoriesProvider = StateNotifierProvider<CategoryNotifier, List<Category>>((ref) => CategoryNotifier());

final categoryProvider = Provider.family<Category?, String>((ref, id) {
  final categories = ref.watch(categoriesProvider);

  if (categories.isEmpty) {
    return null;
  }

  return categories.firstWhere((c) => c.id == id);
});
