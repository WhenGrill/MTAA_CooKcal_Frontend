import 'dart:convert';
import 'dart:io';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:cookcal/HTTP/recipes_operations.dart';
import 'package:cookcal/Screens/Recipes/addRecipe_screen.dart';
import 'package:cookcal/Screens/home_screen.dart';
import 'package:cookcal/Screens/Login_register/register_screen.dart';
import 'package:cookcal/Status_code_handling/status_code_handling.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:cookcal/Widgets/myProgressbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../HTTP/login_register.dart';
import '../../Utils/api_const.dart';
import '../../Widgets/mySnackBar.dart';
import '../../Widgets/neomoprishm_box.dart';
import '../../model/recipes.dart';
import '../../model/users.dart';
import '../MainNavigation_screen.dart';
import 'editRecipe_screen.dart';

class RecipeProfileScreen extends StatefulWidget {
  final RecipeOut recipe;
  final int? curr_id;
  final ImageProvider? rImage;
  const RecipeProfileScreen({Key? key, required this.recipe, required this.curr_id, required this.rImage}) : super(key: key);
  @override
  _RecipeProfileScreenState createState() => _RecipeProfileScreenState();
}

class _RecipeProfileScreenState extends State<RecipeProfileScreen> {
  late RecipeOut recipe = widget.recipe;
  late int? curr_id = widget.curr_id;
  late ImageProvider? rImage = widget.rImage;
  bool isLoading = false;
  File? image;

  RecipesOperations recipesOperations = RecipesOperations();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_WHITE,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: COLOR_WHITE, //change your color here
        ),
        title: Text('CooKcal', style: TextStyle(color: COLOR_WHITE)),
        centerTitle: true,
        backgroundColor: COLOR_VERYDARKPURPLE,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                color: COLOR_WHITE,
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          width: constraints.maxWidth,
                          height: 220.0,
                          decoration: BoxDecoration(
                            color: COLOR_VERYDARKPURPLE,
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                            border: Border.all(
                              color: COLOR_DARKPURPLE,
                              width: 7.0,
                            ),
                          ),
                          child: image != null ? Image.file(image!, fit: BoxFit.cover):
                          (rImage != null ? Image(image: rImage!) : assert_to_image(context, food_icons[random(0, 4)]))
                          ,
                        ),
                      ],
                    ),
                    addVerticalSpace(15),
                    Container(
                        width: constraints.maxWidth* 0.95,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Text('${recipe.title}',
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: COLOR_PURPLE),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                            ),
                          ),
                        ),
                        decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 4, 30)
                    ),
                    addVerticalSpace(15),
                    Container(
                        width: constraints.maxWidth* 0.95,
                        child: Padding(
                          padding: EdgeInsets.all(5),
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
                        decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 4, 30)
                    ),
                    addVerticalSpace(15),
                    Container(
                        width: constraints.maxWidth* 0.95,
                        child: Padding(
                          padding: EdgeInsets.all(5),
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
                        decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 4, 30)
                    ),
                    addVerticalSpace(15),
                    Container(
                        width: constraints.maxWidth* 0.95,
                        child: Padding(
                          padding: EdgeInsets.all(5),
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
                        decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 4, 30)
                    ),
                    addVerticalSpace(15),
                    Container(
                        width: constraints.maxWidth* 0.95,
                        child: Padding(
                          padding: EdgeInsets.all(5),
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
                        decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 4, 20)
                    ),
                    addVerticalSpace(15),
                    if (curr_id == recipe.creator["id"])
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            heroTag: "edit",
                            onPressed: () async {
                              RecipeUpdate data = RecipeUpdate(
                                title: recipe.title,
                                ingredients: recipe.ingredients,
                                instructions: recipe.instructions,
                                kcal_100g: recipe.kcal_100g,
                              );
                              setState(() {
                                isLoading = true;
                              });
                              var rImage = await recipesOperations.get_recipe_image(recipe.id);
                              setState(() {
                                isLoading = false;
                              });
                              await failedAPICallsQueue.execute_all_pending();
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> EditRecipeScreen(data: data, id: recipe.id, rImage: rImage,)));
                            },
                            backgroundColor: COLOR_DARKMINT,
                            child: Icon(Icons.edit),
                          ),
                          FloatingActionButton(
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
                                        height: 155,
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
                                                        setState(() {
                                                          isLoading = true;
                                                        });
                                                        var response = await recipesOperations.delete_recipe(recipe.id);
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                        if (response == null){
                                                          Navigator.pop(context);
                                                          Navigator.pop(context);
                                                          {
                                                            var RecipesCache = await APICacheManager().getCacheData("Recipes");
                                                            var ori_cache_data = json.decode(RecipesCache.syncData);
                                                            int i = 0;
                                                            List<dynamic> cache_data = ori_cache_data['detail'];
                                                            for (var recipes in cache_data){
                                                              if (recipes['id'] == recipe.id){
                                                                i = cache_data.indexOf(recipes);
                                                              }
                                                            }
                                                            ori_cache_data["detail"].removeAt(i);
                                                            APICacheDBModel cacheDBModel = new APICacheDBModel(key: "Recipes", syncData: json.encode(ori_cache_data));
                                                            await APICacheManager().addCacheData(cacheDBModel);
                                                            mySnackBar(context,  Colors.orange, COLOR_WHITE, offline, Icons.storage_rounded);
                                                          }
                                                        }
                                                        else if (response.statusCode == 204){
                                                          Navigator.pop(context);
                                                          Navigator.pop(context);
                                                          mySnackBar(context, COLOR_DARKMINT, COLOR_WHITE, 'Recipe successfully deleted', Icons.check_circle);
                                                        }
                                                        else if (response.statusCode == 401){
                                                          Navigator.pop(context);
                                                          Navigator.pop(context);
                                                          Navigator.pop(context);
                                                          mySnackBar(context, Colors.red, COLOR_WHITE, loginEx, Icons.close);
                                                        }
                                                        else if (response.statusCode == 404) {
                                                          Navigator.pop(context);
                                                          mySnackBar(context, Colors.red, COLOR_WHITE, "User not found", Icons.close);
                                                        }
                                                        else{
                                                          Navigator.pop(context);
                                                          mySnackBar(context, Colors.red, COLOR_WHITE, unknowError, Icons.close);
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
                        ],
                      ),
                    addVerticalSpace(35)
                  ],
                ),
              ),
            ),
            myProgressBar(isLoading)
          ],
        );
      }),
    );
  }
}