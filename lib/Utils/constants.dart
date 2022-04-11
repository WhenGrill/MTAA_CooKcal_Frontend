import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const COLOR_BLACK = Colors.black;
const COLOR_ORANGE = Color(0xffffd269);
const COLOR_CREAME = Color(0xffF0BB62);
const COLOR_WHITE = Color(0xffeeeeff);
const COLOR_GREEN = Color(0xff244026);
const COLOR_DARKGREEN = Color(0xff003004);
const COLOR_GREY = Color(0xffeeeeee);

const gradientColors = [
  COLOR_GREEN, COLOR_ORANGE, COLOR_GREEN,
];

const List<String> food_icons = [
  "assets/images/diet.png",
  "assets/images/dish.png",
  "assets/images/fast-food.png",
  "assets/images/hamburger.png",
  "assets/images/salad.png",
];

const List<String> user_icons = [
  "assets/images/man.png",
  "assets/images/woman.png",
  "assets/images/user.png",
];

TextTheme defaultText = TextTheme(
    headline1: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 96),
    headline2: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 60),
    headline3: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 48),
    headline4: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 34),
    headline5: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 24),
    headline6: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 20),
    bodyText1: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.normal),
    bodyText2: GoogleFonts.nunito(
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    subtitle1: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.normal),
    subtitle2: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w400),
    button: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w400),
    caption: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.normal));

//delete later
class Recipe {
  late String title;
  late String creator;
  late String ingredients;
  late String instructions;
  late String kcal;

  Recipe({
    required this.title,
    required this.creator,
    required this.ingredients,
    required this.instructions,
    required this.kcal
  });

}

List<Recipe> recipes = [
  Recipe(title: 'burger', ingredients: 'bread, hotdog, whatever', kcal: '125', instructions: 'make the damn burger', creator: 'Jan Balazia'),
  Recipe(title: 'figa', ingredients: 'bread, hotdog, whatever', kcal: '125', instructions: 'make the damn burger', creator: 'Jan Balazia'),
  Recipe(title: 'borova', ingredients: 'bread, hotdog, whatever', kcal: '125', instructions: 'make the damn burger', creator: 'Simonka Hospitalizovaná'),
  Recipe(title: 'S chlebom', ingredients: 'bread, hotdog, whatever', kcal: '125', instructions: 'make the damn burger', creator: 'Jan Balazia'),
  Recipe(title: 'makova', ingredients: 'bread, hotdog, whatever', kcal: '125', instructions: 'make the damn burger', creator: 'Jan Balazia'),
  Recipe(title: 'Dentík', ingredients: 'bread, hotdog, whatever', kcal: '125', instructions: 'make the damn burger', creator: 'Andrej Zbytčan'),
  Recipe(title: 'vreckovka', ingredients: 'bread, hotdog, whatever', kcal: '125', instructions: 'make the damn burger', creator: 'Jan Balazia'),
  Recipe(title: 'Ponožka', ingredients: 'bread, hotdog, whatever', kcal: '125', instructions: 'make the damn burger', creator: 'Jan Balazia'),
  Recipe(title: 'burger', ingredients: 'bread, hotdog, whatever', kcal: '125', instructions: 'make the damn burger', creator: 'Jan Balazia'),
  Recipe(title: 'figa', ingredients: 'bread, hotdog, whatever', kcal: '125', instructions: 'make the damn burger', creator: 'Jan Balazia'),
  Recipe(title: 'borova', ingredients: 'bread, hotdog, whatever', kcal: '125', instructions: 'make the damn burger', creator: 'Simonka Hospitalizovaná'),
  Recipe(title: 'S chlebom', ingredients: 'bread, hotdog, whatever', kcal: '125', instructions: 'make the damn burger', creator: 'Jan Balazia'),
  Recipe(title: 'makova', ingredients: 'bread, hotdog, whatever', kcal: '125', instructions: 'make the damn burger', creator: 'Jan Balazia'),
  Recipe(title: 'Dentík', ingredients: 'bread, hotdog, whatever', kcal: '125', instructions: 'make the damn burger', creator: 'Andrej Zbytčan'),
  Recipe(title: 'vreckovka', ingredients: 'bread, hotdog, whatever', kcal: '125', instructions: 'make the damn burger', creator: 'Jan Balazia'),
  Recipe(title: 'Ponožka', ingredients: 'bread, hotdog, whatever', kcal: '125', instructions: 'make the damn burger', creator: 'Jan Balazia'),

];

class UserExample {
  late int id;
  late String first_name;
  late String last_name;
  late int gender;
  late int age;
  late int state;
  late bool is_nutr_adviser;

  UserExample({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.gender,
    required this.age,
    required this.state,
    required this.is_nutr_adviser
  });
}
  List<UserExample> users = [
    UserExample(id: 1, first_name: "Milena", last_name: "Menová", gender: 1, age: 32, state: 0, is_nutr_adviser: true),
    UserExample(id: 2, first_name: "Roberta", last_name: "Menová", gender: 1, age: 32, state: 0, is_nutr_adviser: true),
    UserExample(id: 3, first_name: "Ivan", last_name: "Menovy", gender: 0, age: 32, state: 0, is_nutr_adviser: true),
    UserExample(id: 4, first_name: "Milena", last_name: "Menová", gender: 1, age: 32, state: 0, is_nutr_adviser: true),
    UserExample(id: 5, first_name: "Ivan", last_name: "Menovy", gender: 0, age: 32, state: 0, is_nutr_adviser: true),
    UserExample(id: 6, first_name: "Ivan", last_name: "Menovy", gender: 0, age: 32, state: 0, is_nutr_adviser: true),
    UserExample(id: 7, first_name: "Judit", last_name: "Menovo", gender: 2, age: 32, state: 0, is_nutr_adviser: true),
    UserExample(id: 8, first_name: "Milena", last_name: "Menová", gender: 1, age: 32, state: 0, is_nutr_adviser: true),
    UserExample(id: 9, first_name: "Ivan", last_name: "Menovy", gender: 0, age: 32, state: 0, is_nutr_adviser: true),
    UserExample(id: 10, first_name: "Milena", last_name: "Menová", gender: 1, age: 32, state: 0, is_nutr_adviser: true),
    UserExample(id: 11, first_name: "Karen", last_name: "Menovo", gender: 2, age: 32, state: 0, is_nutr_adviser: true),
    UserExample(id: 12, first_name: "Milena", last_name: "Menová", gender: 1, age: 32, state: 0, is_nutr_adviser: true),


  ];