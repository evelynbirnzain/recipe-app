import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String id;
  final String name;
  final DocumentReference category;
  final List<String> ingredients;
  final List<String> steps;

  Recipe(
      {required this.id,
      required this.name,
      required this.category,
      required this.ingredients,
      required this.steps});

  factory Recipe.fromFirestore(Map<String, dynamic> data, String id) {
    return Recipe(
      id: id,
      name: data['name'],
      category: data['category'],
      ingredients: data['ingredients'].cast<String>(),
      steps: data['steps'].cast<String>(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'ingredients': ingredients,
      'steps': steps,
    };
  }
}
