import 'package:dio/dio.dart';

import 'package:cookcal/model/users.dart';

class RecipeCreate {
  final String title;
  final String ingredients;
  final String instructions;
  final double kcal_100g;

  RecipeCreate({
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.kcal_100g,
  });

  factory RecipeCreate.fromJson(Map<String, dynamic> json) {
    return RecipeCreate(
      title: json['title'],
      ingredients: json['ingredients'],
      instructions: json['instructions'],
      kcal_100g: json['kcal_100g'],
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'ingredients': ingredients,
    'instructions': instructions,
    'kcal_100g': kcal_100g,
  };

  static List<RecipeCreate> listFromJson(List<dynamic> list) =>
      List<RecipeCreate>.from(list.map((x) => RecipeCreate.fromJson(x)));
}

class RecipeOut {
  final int id;
  final String title;
  final String ingredients;
  final String instructions;
  final double kcal_100g;
  final Map<String, dynamic> creator;

  RecipeOut({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.kcal_100g,
    required this.creator
  });

  factory RecipeOut.fromJson(Map<String, dynamic> json) {
    return RecipeOut(
      id: json['id'],
      title: json['title'],
      ingredients: json['ingredients'],
      instructions: json['instructions'],
      kcal_100g: json['kcal_100g'],
      creator: json['creator'],
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'ingredients': ingredients,
    'instructions': instructions,
    'kcal_100g': kcal_100g,
    'creator': creator,
  };
  

  static List<RecipeOut> listFromJson(List<dynamic> list) =>
      List<RecipeOut>.from(list.map((x) => RecipeOut.fromJson(x)));

}

class RecipeIn {
  final String title;
  final String ingredients;
  final String instructions;
  final double kcal_100g;

  RecipeIn({
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.kcal_100g,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'ingredients': ingredients,
    'instructions': instructions,
    'kcal_100g': kcal_100g
  };
}
