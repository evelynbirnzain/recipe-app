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

  void addRecipe(Recipe recipe) async {
    final recipeData = recipe.toFirestore();
    final recipeRef = await _firestore.collection('recipes').add(recipeData);
    final savedRecipe = Recipe.fromFirestore(recipeData, recipeRef.id);
    state = [...state, savedRecipe];
  }

  void deleteRecipe(String id) async {
    await _firestore.collection('recipes').doc(id).delete();
    state = state.where((recipe) => recipe.id != id).toList();
  }

  void toggle(String id, String uid) async {
    final recipe = state.firstWhere((recipe) => recipe.id == id);
    final likes = recipe.favorites;
    if (likes.contains(uid)) {
      likes.remove(uid);
    } else {
      likes.add(uid);
    }
    final recipeData = recipe.toFirestore();
    await _firestore.collection('recipes').doc(id).update(recipeData);
    state = state.map((recipe) {
      if (recipe.id == id) {
        return Recipe.fromFirestore(recipeData, recipe.id);
      } else {
        return recipe;
      }
    }).toList();
  }
}

final recipesProvider = StateNotifierProvider<RecipeNotifier, List<Recipe>>((ref) => RecipeNotifier());

final recipeProvider = Provider.family<Recipe, String>((ref, id) {
  final recipes = ref.watch(recipesProvider);
  return recipes.firstWhere((recipe) => recipe.id == id);
});
