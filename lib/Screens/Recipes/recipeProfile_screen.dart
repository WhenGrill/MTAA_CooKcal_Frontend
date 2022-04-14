import 'dart:io';

import 'package:cookcal/Screens/home_screen.dart';
import 'package:cookcal/Screens/Login_register/register_screen.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../HTTP/login_register.dart';
import '../../model/recipes.dart';
import '../../model/users.dart';
import '../MainNavigation_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_WHITE,
      appBar: AppBar(
        title: Text('CooKcal'),
        centerTitle: true,
        backgroundColor: COLOR_GREEN,
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
                        color: COLOR_ORANGE,
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        border: Border.all(
                          color: COLOR_GREEN,
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
                                onPressed: () {},
                                backgroundColor: COLOR_GREEN,
                                child: Icon(Icons.edit),
                              ),
                            ),
                          ),
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
                                heroTag: "photo",
                                onPressed: () {},
                                backgroundColor: COLOR_ORANGE,
                                child: Icon(Icons.photo),
                              ),
                            ),
                          ),
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
                                onPressed: () {},
                                backgroundColor: Colors.red,
                                child: Icon(Icons.delete_forever_rounded),
                              ),
                            ),
                          ),
                          addVerticalSpace(20),

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
                              child: Text('${recipe.ingredients}', style: TextStyle(fontSize: 20)),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text("\nInstructions: ", style: TextStyle(fontSize:20, fontWeight: FontWeight.bold)),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text('${recipe.instructions}', style: TextStyle(fontSize: 20)),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text("\nKcal/100g: ", style: TextStyle(fontSize:20, fontWeight: FontWeight.bold)),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text('${recipe.kcal_100g}', style: TextStyle(fontSize: 20)),
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
                        child: Text('${recipe.creator["first_name"]} ${recipe.creator["last_name"]}',
                          style: TextStyle(fontSize: 20),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
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