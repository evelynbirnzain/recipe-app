import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dad_2/providers/recipe_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/recipe.dart';
import '../providers/category_provider.dart';

class RecipeFormWidget extends ConsumerWidget {
  final StateProvider<List<String>> ingredientsProvider;
  final StateProvider<List<String>> stepsProvider;

  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();

  RecipeFormWidget(this.ingredientsProvider, this.stepsProvider,
      [Recipe? recipe]) {
    if (recipe != null) {
      _nameController.text = recipe.name;
      _categoryController.text = recipe.category.id;
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    if (categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final ingredients = ref.watch(ingredientsProvider);
    final steps = ref.watch(stepsProvider);
    _categoryController.text = _categoryController.text.isEmpty
        ? categories.first.id
        : _categoryController.text;

    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: 'Enter recipe name',
            border: OutlineInputBorder(),
          ),
        ),
        DropdownButtonFormField(
          value: _categoryController.text,
          items: categories
              .map((e) => DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name),
                  ))
              .toList(),
          onChanged: (value) {
            print(value);
            _categoryController.text = value.toString();
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        TextField(
          controller: _ingredientsController,
          decoration: const InputDecoration(
            hintText: 'Enter ingredient',
            border: OutlineInputBorder(),
          ),
          maxLines: null,
        ),
        ElevatedButton(
            onPressed: () {
              if (_ingredientsController.text.trim().isEmpty) return;

              ref.read(ingredientsProvider.notifier).state = [
                ...ingredients,
                _ingredientsController.text
              ];
              _ingredientsController.clear();
            },
            child: const Text('Add ingredient')),
        ListView(
          shrinkWrap: true,
          children: ingredients
              .map((e) => Card(
                    child: ListTile(
                      title: Text(e),
                    ),
                  ))
              .toList(),
        ),
        TextField(
          controller: _stepsController,
          decoration: const InputDecoration(
            hintText: 'Enter step',
            border: OutlineInputBorder(),
          ),
          maxLines: null,
        ),
        ElevatedButton(
            onPressed: () {
              if (_stepsController.text.trim().isEmpty) return;

              ref.read(stepsProvider.notifier).state = [
                ...steps,
                _stepsController.text
              ];
              _stepsController.clear();
            },
            child: const Text('Add step')),
        ListView(
          shrinkWrap: true,
          children: steps
              .map((e) => Card(
                    child: ListTile(
                      title: Text(e),
                    ),
                  ))
              .toList(),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.trim().isEmpty ||
                ingredients.isEmpty ||
                steps.isEmpty) {
              return;
            }

            final recipe = Recipe(
              id: '',
              name: _nameController.text,
              category: FirebaseFirestore.instance
                  .collection('categories')
                  .doc(_categoryController.text),
              ingredients: ingredients,
              steps: steps,
            );
            ref.read(recipesProvider.notifier).addRecipe(recipe);
            _nameController.clear();
          },
          child: const Text('Save recipe'),
        ),
      ],
    );
  }
}
