import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dad_2/models/category.dart';

class Recipe {
  final String id;
  final String name;
  final DocumentReference category;
  final String url;
  final List<String> ingredients;
  final List<String> steps;

  Recipe(
      {required this.id,
      required this.name,
      required this.category,
      required this.url,
      required this.ingredients,
      required this.steps});

  factory Recipe.fromFirestore(Map<String, dynamic> data, String id) {
    return Recipe(
      id: id,
      name: data['name'],
      category: data['category'],
      url: data['url'],
      ingredients: data['ingredients'].cast<String>(),
      steps: data['steps'].cast<String>(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'url': url,
      'ingredients': ingredients,
      'steps': steps,
    };
  }
}
