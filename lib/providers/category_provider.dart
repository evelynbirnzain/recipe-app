import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dad_2/models/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryNotifier extends StateNotifier<List<Category>> {
  CategoryNotifier() : super([]) {
    _fetchCategories();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _fetchCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    final categories = snapshot.docs.map((doc) {
      return Category.fromFirestore(doc.data(), doc.id);
    }).toList();

    state = categories;
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
