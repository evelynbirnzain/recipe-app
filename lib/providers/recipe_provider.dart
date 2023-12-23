import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../models/recipe.dart';

class RecipesNotifier extends StateNotifier<Recipe?> {
  final int _pageSize = 20;
  var _search = '';
  var _categoryId = '';
  var _favourites = false;
  var _uid;
  var _lastPageKey;

  final PagingController<int, Recipe> pagingController =
      PagingController(firstPageKey: 0);

  RecipesNotifier() : super(null) {
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _fetchPage(int pageKey) async {
    if (_lastPageKey == pageKey) {
      return;
    }
    _lastPageKey = pageKey;
    print('fetchPage $pageKey: $_categoryId, $_search, $_favourites, $_uid');
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
    return recipe.copyWith(id: saved.id);
  }

  void deleteRecipe(String id) async {
    await _firestore.collection('recipes').doc(id).delete();
  }

  void getFeaturedRecipe() async {
    final snapshot = await _firestore.collection('recipes').limit(1).get();
    final recipe = Recipe.fromFirestore(
        snapshot.docs.first.data(), snapshot.docs.first.id);
    state = recipe;
  }

  Future<Recipe> getRecipe(String id) async {
    final snapshot = await _firestore.collection('recipes').doc(id).get();
    final recipe = Recipe.fromFirestore(snapshot.data()!, snapshot.id);
    state = recipe;
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
        pagingController.itemList?.indexWhere((recipe) => recipe.id == id);

    print("idx: $index");
    if (index != null && index >= 0) {
      pagingController.itemList?[index] = recipe;
      _lastPageKey = null;
      pagingController.refresh();
    }
  }

  void setFilter(
      String categoryId, String search, bool favourites, String? uid) {

    print('currentFilter: $_categoryId, $_search, $_favourites, $_uid');

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

    print('setFilter: $_categoryId, $_search, $_favourites, $_uid');

    _lastPageKey = null;
    pagingController.refresh();
  }

  void fetchRecipe(String id) async {
    final snapshot = await _firestore.collection('recipes').doc(id).get();
    final recipe = Recipe.fromFirestore(snapshot.data()!, snapshot.id);
    state = recipe;
  }
}

final recipesProvider = StateNotifierProvider<RecipesNotifier, Recipe?>((ref) {
  return RecipesNotifier();
});

final recipeProvider = Provider.family<Recipe?, String>((ref, id) {
  final recipe = ref.watch(recipesProvider);
  if (recipe?.id == id) {
    return recipe;
  }
  ref.read(recipesProvider.notifier).getRecipe(id);
  return null;
});

final featuredRecipeProvider = Provider<Recipe?>((ref) {
  final recipe = ref.watch(recipesProvider);
  if (recipe != null) {
    return recipe;
  }
  ref.read(recipesProvider.notifier).getFeaturedRecipe();
  return null;
});
