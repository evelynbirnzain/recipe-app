import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../models/recipe.dart';

class RecipeNotifier extends StateNotifier<List<Recipe>> {
  final int _pageSize = 3;
  var _search = '';
  var _categoryId = '';
  var _favourites = false;
  var _uid;

  final PagingController<int, Recipe> pagingController =
      PagingController(firstPageKey: 0);

  RecipeNotifier() : super([]) {
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _fetchPage(int pageKey) async {
    try {
      Query<Map<String, dynamic>> query = _firestore.collection('recipes');

      if (_categoryId != '') {
        query = query.where('category',
            isEqualTo: _firestore.doc('categories/$_categoryId'));
      } else if (_search != '') {
        query = query
            .where('name', isGreaterThanOrEqualTo: _search)
            .where('name', isLessThanOrEqualTo: _search + '\uf8ff');
      } else if (_favourites) {
        query = query.where('likes', arrayContains: _uid);
      }

      query = query.orderBy('name').orderBy('id').limit(_pageSize);
      QuerySnapshot<Map<String, dynamic>> snapshot;
      if (pageKey == 0) {
        snapshot = await query.get();
      } else {
        final last = pagingController.itemList!.last;
        snapshot = await query.startAfter([last.name, last.id]).get();
      }

      final recipes = snapshot.docs.map((doc) {
        return Recipe.fromFirestore(doc.data(), doc.id);
      }).toList();

      final isLastPage = recipes.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(recipes);
      } else {
        final nextPageKey = pageKey + recipes.length;
        pagingController.appendPage(recipes, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
      print(error);
    }
  }

  Future<Recipe> addRecipe(Recipe recipe) async {
    final recipeData = recipe.toFirestore();
    final saved = await _firestore.collection('recipes').add(recipeData);
    state = [recipe.copyWith(id: saved.id)];
    return recipe.copyWith(id: saved.id);
  }

  void deleteRecipe(String id) async {
    await _firestore.collection('recipes').doc(id).delete();
  }

  void toggle(String id, String uid) async {
    final recipe =
        pagingController.itemList!.firstWhere((recipe) => recipe.id == id);
    final likes = recipe.favorites;
    if (likes.contains(uid)) {
      likes.remove(uid);
    } else {
      likes.add(uid);
    }
    final recipeData = recipe.toFirestore();
    await _firestore.collection('recipes').doc(id).update(recipeData);

    final index =
        pagingController.itemList!.indexWhere((recipe) => recipe.id == id);
    pagingController.itemList![index] = recipe;

    pagingController.refresh();
  }

  void setFilter(
      String categoryId, String search, bool favourites, String? uid) {
    _categoryId = categoryId;
    _search = search;
    _favourites = favourites;
    _uid = uid;

    print('setFilter: $_categoryId, $_search, $_favourites, $_uid');

    pagingController.refresh();
  }

  void fetchRecipe(String id) async {
    final snapshot = await _firestore.collection('recipes').doc(id).get();
    final recipe = Recipe.fromFirestore(snapshot.data()!, snapshot.id);
    state = [recipe];
  }

  void getFeaturedRecipe() async {
    final snapshot = await _firestore.collection('recipes').limit(1).get();
    final recipe = Recipe.fromFirestore(snapshot.docs.first.data(), snapshot.docs.first.id);
    state = [recipe];
  }
}

final recipesProvider =
    StateNotifierProvider<RecipeNotifier, List<Recipe>>((ref) {
  return RecipeNotifier();
});

final recipeProvider = Provider.family<Recipe, String>((ref, id) {
  ref.watch(recipesProvider.notifier).fetchRecipe(id);
  final recipes = ref.watch(recipesProvider);
  return recipes.firstWhere((recipe) => recipe.id == id);
});

final featuredRecipeProvider = Provider<Recipe>((ref) {
  ref.watch(recipesProvider.notifier).getFeaturedRecipe();
  final recipes = ref.watch(recipesProvider);
  return recipes.first;
});
