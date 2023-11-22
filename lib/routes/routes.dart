import 'package:dad_2/screens/recipe/edit_recipe_screen.dart';
import 'package:dad_2/screens/recipe/favourite_recipes_screen.dart';
import 'package:dad_2/screens/recipe/new_recipe_screen.dart';
import 'package:dad_2/screens/recipe_category_screen.dart';
import 'package:dad_2/screens/recipe/recipe_list_screen.dart';
import 'package:dad_2/screens/recipe/recipe_screen.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';

final routes = [
  GoRoute(path: '/', builder: (context, state) => HomeScreen()),
  GoRoute(
      path: '/recipes/:id',
      builder: (context, state) => RecipeDetailsScreen(state.pathParameters['id']!)),
  GoRoute(
      path: '/recipes',
      builder: (context, state) {
        return RecipeListScreen(state.uri.queryParameters['categoryId'],
            state.uri.queryParameters['search']);
      }),
  GoRoute(
      path: '/favorites',
      builder: (context, state) => FavouriteRecipesScreen()),
  GoRoute(
      path: '/categories', builder: (context, state) => RecipeCategoryScreen()),
  GoRoute(path: '/new-recipe', builder: (context, state) => NewRecipeScreen()),
  GoRoute(
      path: '/recipes/:id/edit',
      builder: (context, state) =>
          EditRecipeScreen(state.pathParameters['id']!)),
];
