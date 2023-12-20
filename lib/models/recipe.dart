import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String id;
  final String name;
  final DocumentReference category;
  final List<String> ingredients;
  final List<String> steps;
  final String author;
  final List<String> favorites;

  Recipe(
      {required this.id,
      required this.name,
      required this.category,
      required this.ingredients,
      required this.steps,
      required this.author,
      this.favorites = const []});

  factory Recipe.fromFirestore(Map<String, dynamic> data, String id) {
    return Recipe(
      id: id,
      name: data['name'],
      category: data['category'],
      ingredients: data['ingredients'].cast<String>(),
      steps: data['steps'].cast<String>(),
      author: data['author'],
      favorites: data['likes']?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'ingredients': ingredients,
      'steps': steps,
      'author': author,
      'likes': favorites,
    };
  }

  copyWith({
    String? id,
    String? name,
    DocumentReference? category,
    List<String>? ingredients,
    List<String>? steps,
    String? author,
    List<String>? favorites,
  }) {
    return Recipe(
      id: id ?? this.id,
      author: author ?? this.author,
      name: name ?? this.name,
      category: category ?? this.category,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
    );
  }
}
