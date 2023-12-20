import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dad_2/providers/recipe_provider.dart';
import 'package:dad_2/widgets/util/section_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/recipe.dart';
import '../../providers/category_provider.dart';
import '../../providers/user_provider.dart';

class RecipeFormWidget extends ConsumerWidget {
  final StateProvider<List<String>> ingredientsProvider;
  final StateProvider<List<String>> stepsProvider;

  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();

  final Recipe? recipe;

  RecipeFormWidget(this.ingredientsProvider, this.stepsProvider,
      [this.recipe]) {
    if (recipe != null) {
      _nameController.text = recipe!.name;
      _categoryController.text = recipe!.category.id;
    }
  }

  RecipeFormWidget.add()
      : this(
          StateProvider((ref) => []),
          StateProvider((ref) => []),
        );

  RecipeFormWidget.edit(Recipe recipe)
      : this(
          StateProvider((ref) => recipe.ingredients),
          StateProvider((ref) => recipe.steps),
          recipe,
        );

  void submitIngredient(WidgetRef ref, List<String> ingredients) {
    if (_ingredientsController.text.trim().isEmpty) return;

    ref.read(ingredientsProvider.notifier).state = [
      ...ingredients,
      _ingredientsController.text
    ];
    _ingredientsController.clear();
  }

  void submitStep(WidgetRef ref, List<String> steps) {
    if (_stepsController.text.trim().isEmpty) return;

    ref.read(stepsProvider.notifier).state = [...steps, _stepsController.text];
    _stepsController.clear();
  }

  void onSubmit(WidgetRef ref, List<String> ingredients, List<String> steps,
      AsyncValue<User?> user, BuildContext context) {
    if (_nameController.text.trim().isEmpty ||
        ingredients.isEmpty ||
        steps.isEmpty) {
      return;
    }

    final recipe = Recipe(
      id: this.recipe == null ? '' : this.recipe!.id,
      name: _nameController.text,
      category: FirebaseFirestore.instance
          .collection('categories')
          .doc(_categoryController.text),
      ingredients: ingredients,
      steps: steps,
      author: user.value!.uid,
    );

    ref
        .read(recipesProvider.notifier)
        .addRecipe(recipe)
        .then((value) => context.go('/recipes/${value.id}'));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final user = ref.watch(userProvider);

    if (categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final ingredients = ref.watch(ingredientsProvider);
    final steps = ref.watch(stepsProvider);
    _categoryController.text = _categoryController.text.isEmpty
        ? categories.first.id
        : _categoryController.text;

    return Expanded(
        child: ListView(
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: 'Enter recipe name',
            border: OutlineInputBorder(),
          ),
        ),
        const SectionHeader("Ingredients", leading: Icon(Icons.shopping_cart)),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _ingredientsController,
                onEditingComplete: () => submitIngredient(ref, ingredients),
                decoration: const InputDecoration(
                  hintText: 'Enter ingredient',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(
                icon: const Icon(Icons.add),
                color: Theme.of(context).primaryColor,
                onPressed: () => submitIngredient(ref, ingredients),
                tooltip: 'Add ingredient'),
          ],
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              if (ingredients.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              final ingredient = ingredients[index];
              return Card(
                  child: ListTile(
                      title: Text(ingredient),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          ingredients.removeAt(index);
                          ref.read(ingredientsProvider.notifier).state =
                              ingredients.toList();
                        },
                      )));
            }),
        const SectionHeader("Steps", leading: Icon(Icons.list)),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _stepsController,
                onEditingComplete: () => submitStep(ref, steps),
                decoration: const InputDecoration(
                  hintText: 'Enter step',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(
                icon: const Icon(Icons.add),
                color: Theme.of(context).primaryColor,
                onPressed: () => submitStep(ref, steps),
                tooltip: 'Add step'),
          ],
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: steps.length,
            itemBuilder: (context, index) {
              if (steps.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              final step = steps[index];
              return Card(
                  child: ListTile(
                title: Text(step),
                leading: Text('${index + 1}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    steps.removeAt(index);
                    ref.read(stepsProvider.notifier).state = steps.toList();
                  },
                ),
              ));
            }),
        const SectionHeader("Category", leading: Icon(Icons.category)),
        DropdownButtonFormField(
          value: _categoryController.text,
          items: categories
              .map((e) => DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name),
                  ))
              .toList(),
          onChanged: (value) {
            _categoryController.text = value.toString();
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () => onSubmit(ref, ingredients, steps, user, context),
              child: const Text('Save recipe'),
            )),
      ],
    ));
  }
}
