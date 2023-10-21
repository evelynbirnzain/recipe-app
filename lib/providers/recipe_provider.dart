import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';

class RecipeNotifier extends StateNotifier<List<Recipe>> {
  RecipeNotifier() : super([]) {
    _fetchRecipes();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _fetchRecipes() async {
    final snapshot = await _firestore.collection('recipes').get();
    final recipes = snapshot.docs.map((doc) {
      return Recipe.fromFirestore(doc.data(), doc.id);
    }).toList();

    state = recipes;
  }
}

final recipesProvider = StateNotifierProvider<RecipeNotifier, List<Recipe>>((ref) => RecipeNotifier());

final recipeProvider = Provider.family<Recipe, String>((ref, id) {
  final recipes = ref.watch(recipesProvider);
  return recipes.firstWhere((recipe) => recipe.id == id);
});
