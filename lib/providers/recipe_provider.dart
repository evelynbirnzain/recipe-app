import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../models/recipe.dart';

class RecipeNotifier extends StateNotifier<Recipe?> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RecipeNotifier() : super(null);

  void getRecipe(String id) async {
    if (id == '') {
      final snapshot = await _firestore.collection('recipes').limit(1).get();
      final recipe = Recipe.fromFirestore(
          snapshot.docs.first.data(), snapshot.docs.first.id);
      state = recipe;
      return;
    }
    final snapshot = await _firestore.collection('recipes').doc(id).get();
    final recipe = Recipe.fromFirestore(snapshot.data()!, snapshot.id);
    state = recipe;
  }
}

class PagingControllerProvider extends StateNotifier<PagingController<int, Recipe>> {
  final int _pageSize = 20;
  var _search = '';
  var _categoryId = '';
  var _favourites = false;
  String? _uid;
  int? _lastPageKey;

  PagingControllerProvider() : super(PagingController(firstPageKey: 0)) {
    state.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _fetchPage(int pageKey) async {
    if (_lastPageKey == pageKey) {
      return;
    }
    _lastPageKey = pageKey;
    try {
      Query<Map<String, dynamic>> query = _firestore.collection('recipes');

      if (_categoryId != '') {
        query = query.where('category',
            isEqualTo: _firestore.doc('categories/$_categoryId'));
      } else if (_search != '') {
        query = query
            .where('name', isGreaterThanOrEqualTo: _search)
            .where('name', isLessThanOrEqualTo: '$_search\uf8ff');
      } else if (_favourites) {
        query = query.where('likes', arrayContains: _uid);
      }

      query = query.orderBy('name').orderBy('id').limit(_pageSize);
      QuerySnapshot<Map<String, dynamic>> snapshot;
      if (pageKey == 0) {
        snapshot = await query.get();
      } else {
        final last = state.itemList!.last;
        snapshot = await query.startAfter([last.name, last.id]).get();
      }

      final recipes = snapshot.docs.map((doc) {
        return Recipe.fromFirestore(doc.data(), doc.id);
      }).toList();

      final isLastPage = recipes.length < _pageSize;
      if (isLastPage) {
        state.appendLastPage(recipes);
      } else {
        final nextPageKey = pageKey + recipes.length;
        state.appendPage(recipes, nextPageKey);
      }
    } catch (error) {
      state.error = error;
      print(error);
    }
  }

  Future<Recipe> addRecipe(Recipe recipe) async {
    final recipeData = recipe.toFirestore();
    final saved = await _firestore.collection('recipes').add(recipeData);

    state.itemList?.add(recipe.copyWith(id: saved.id));
    state.refresh();

    return recipe.copyWith(id: saved.id);
  }

  void deleteRecipe(String id) async {
    await _firestore.collection('recipes').doc(id).delete();
    state.itemList?.removeWhere((recipe) => recipe.id == id);
    state.refresh();
  }

  Future<Recipe> getRecipe(String id) async {
    final snapshot = await _firestore.collection('recipes').doc(id).get();
    final recipe = Recipe.fromFirestore(snapshot.data()!, snapshot.id);
    return recipe;
  }

  void toggleFavourite(String id, String uid) async {
    if (uid == '') {
      return;
    }

    final recipe = await getRecipe(id);
    final likes = recipe.favorites;
    if (likes.contains(uid)) {
      likes.remove(uid);
    } else {
      likes.add(uid);
    }
    final recipeData = recipe.toFirestore();
    await _firestore.collection('recipes').doc(id).update(recipeData);

    final index =
        state.itemList?.indexWhere((recipe) => recipe.id == id);

    if (index != null && index >= 0) {
      state.itemList?[index] = recipe;
      _lastPageKey = null;
      state.refresh();
    }
  }

  void setFilter(
      String categoryId, String search, bool favourites, String? uid) {
    if (_categoryId == categoryId &&
        _search == search &&
        _favourites == favourites &&
        _uid == uid) {
      return;
    }

    _categoryId = categoryId;
    _search = search;
    _favourites = favourites;
    _uid = uid;
    _lastPageKey = null;
    state.refresh();
  }
}

final recipesProvider =
    StateNotifierProvider<PagingControllerProvider, PagingController<int, Recipe>>((ref) {
  return PagingControllerProvider();
});

final _recipeProvider = StateNotifierProvider<RecipeNotifier, Recipe?>((ref) {
  return RecipeNotifier();
});

final recipeProvider = Provider.family<Recipe?, String>((ref, id) {
  final recipe = ref.watch(_recipeProvider);
  if (recipe == null || recipe.id != id) {
    ref.read(_recipeProvider.notifier).getRecipe(id);
  }
  return recipe;
});

final _featuredRecipeProvider =
    StateNotifierProvider<RecipeNotifier, Recipe?>((ref) {
  return RecipeNotifier();
});

final featuredRecipeProvider = Provider<Recipe?>((ref) {
  final recipe = ref.watch(_featuredRecipeProvider);
  if (recipe == null) {
    ref.read(_featuredRecipeProvider.notifier).getRecipe('');
  }
  return recipe;
});
