import 'dart:io';

import 'package:cookcal/HTTP/all_recipes.dart';
import 'package:cookcal/Screens/Recipes/addRecipe_screen.dart';
import 'package:cookcal/Screens/home_screen.dart';
import 'package:cookcal/Screens/Login_register/register_screen.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../HTTP/login_register.dart';
import '../../model/recipes.dart';
import '../../model/users.dart';
import '../MainNavigation_screen.dart';
import 'editRecipe_screen.dart';

class RecipeProfileScreen extends StatefulWidget {
  final RecipeOut recipe;
  final int curr_id;
  const RecipeProfileScreen({Key? key, required this.recipe, required this.curr_id}) : super(key: key);
  @override
  _RecipeProfileScreenState createState() => _RecipeProfileScreenState();
}

class _RecipeProfileScreenState extends State<RecipeProfileScreen> {
  late RecipeOut recipe = widget.recipe;
  late int curr_id = widget.curr_id;
  File? image;

  RecipesOperations recipesOperations = RecipesOperations();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_WHITE,
      appBar: AppBar(
        title: Text('CooKcal'),
        centerTitle: true,
        backgroundColor: COLOR_DARKPURPLE,
        actions: [
          IconButton(onPressed: (){

          }, icon: Icon(Icons.settings))
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            color: COLOR_WHITE,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: constraints.maxWidth,
                      height: 220.0,
                      decoration: BoxDecoration(
                        color: COLOR_VERYDARKPURPLE,
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        border: Border.all(
                          color: COLOR_DARKPURPLE,
                          width: 5.0,
                        ),
                      ),
                      child: image != null
                          ? Image.file(
                          image!,
                          fit: BoxFit.cover
                      ): assert_to_image(context, food_icons[random(0, 4)]),
                    ),
                    if (curr_id == recipe.creator["id"])
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.all(Radius.circular(180)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 7,
                                    blurRadius: 7,
                                    offset: const Offset(3, 5),
                                  ),
                                ],
                              ),
                              child: FloatingActionButton(
                                heroTag: "edit",
                                onPressed: () async {
                                  RecipeUpdate data = RecipeUpdate(
                                      title: recipe.title,
                                      ingredients: recipe.ingredients,
                                      instructions: recipe.instructions,
                                      kcal_100g: recipe.kcal_100g,
                                  );
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> EditRecipeScreen(data: data, id: recipe.id)));
                                },
                                backgroundColor: COLOR_MINT,
                                child: Icon(Icons.edit),
                              ),
                            ),
                          ),
                          addVerticalSpace(13),
                          addVerticalSpace(13),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.all(Radius.circular(180)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 7,
                                    blurRadius: 7,
                                    offset: const Offset(3, 5),
                                  ),
                                ],
                              ),
                              child: FloatingActionButton(
                                heroTag: "delete",
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context){
                                        return AlertDialog(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                          backgroundColor: COLOR_WHITE,
                                          content: Container(
                                            width: 300,
                                            height: 150,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Column(
                                                children: [
                                                  const Text(
                                                    "You are about to delete this recipe.",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: COLOR_BLACK,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Do you wish to proceed?",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: COLOR_BLACK,
                                                        fontSize: 20
                                                    ),
                                                  ),
                                                  addVerticalSpace(20),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        width: 50,
                                                        height: 50,
                                                        child: FloatingActionButton(
                                                          backgroundColor: COLOR_DARKPURPLE,
                                                          onPressed: () async {
                                                            try {
                                                              await recipesOperations.delete_recipe(recipe.id);
                                                              Navigator.pop(context);
                                                              Navigator.pop(context);
                                                            } catch (e) {
                                                              setState(() {
                                                              });
                                                              print(e);
                                                            }
                                                          },
                                                          child: const Icon(Icons.check),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 50,
                                                        height: 50,
                                                        child: FloatingActionButton(
                                                          backgroundColor: COLOR_MINT,
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: const Icon(Icons.close),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                  );
                                },
                                backgroundColor: Colors.red,
                                child: Icon(Icons.delete_forever_rounded),
                              ),
                            ),
                          ),
                          addVerticalSpace(45),

                        ],
                      )
                  ],
                ),
                Container(
                  width: constraints.maxWidth,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text('${recipe.title}',
                          style: TextStyle(fontSize: 25),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                        ),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10.0,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: constraints.maxWidth,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text("Ingredients: ", style: TextStyle(fontSize:20, fontWeight: FontWeight.bold)),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text('${recipe.ingredients}', style: TextStyle(fontSize:  15)),
                            ),
                          ],
                        )
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10.0,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: constraints.maxWidth,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Card(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text("Instructions: ", style: TextStyle(fontSize:20, fontWeight: FontWeight.bold)),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text('${recipe.instructions}', style: TextStyle(fontSize: 15)),
                              ),
                            ],
                          )
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10.0,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: constraints.maxWidth,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Card(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text("Kcal/100g: ", style: TextStyle(fontSize:20, fontWeight: FontWeight.bold)),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text('${recipe.kcal_100g}', style: TextStyle(fontSize: 15)),
                              ),
                            ],
                          )
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10.0,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: constraints.maxWidth,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text("Author: ", style: TextStyle(fontSize:20, fontWeight: FontWeight.bold)),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text("${recipe.creator["first_name"]} ${recipe.creator["last_name"]}", style: TextStyle(fontSize:15)),
                            )
                          ],
                        )
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10.0,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}