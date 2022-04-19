import 'package:cookcal/HTTP/recipes_operations.dart';
import 'package:cookcal/HTTP/users_operations.dart';
import 'package:cookcal/Screens/Recipes/recipeProfile_screen.dart';
import 'package:cookcal/Status_code_handling/status_code_handling.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:cookcal/Widgets/myProgressbar.dart';
import 'package:flutter/material.dart';
import 'package:cookcal/Widgets/searchBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/neomoprishm_box.dart';
import '../../model/recipes.dart';


class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({Key? key}) : super(key: key);

  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {

  final myController = TextEditingController();
  UsersOperations usersOperations = UsersOperations();
  RecipesOperations recipesOp = RecipesOperations();
  List<RecipeOut> recipes = [];
  late int curr_id = 0;
  String last_text = "";
  bool isChecked = false;
  bool isLoading = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  load_data(String text) async {
    var response = await RecipesOperations().get_all_recipes(text);

    if (response == null || response.statusCode != 200){
      return response;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    curr_id = prefs.getInt("user_id")!;

    List<RecipeOut> recipes_data = List<RecipeOut>.from(
        response.data.map((x) => RecipeOut.fromJson(x)));

    recipes.clear();

    if (isChecked){
      recipes_data.forEach((element) {
        if (element.creator['id'] == curr_id) {
          recipes.add(element);
        }
      });
    } else {
      recipes_data.forEach((element) {
        recipes.add(element);
        print(element.id);
      });
    }

    return response;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_WHITE,
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(builder: (context, constraints){
        return Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: RoundedSearchInput(
                    hintText: 'Search here',
                    textController: myController,
                  ),
                ),
                addVerticalSpace(constraints.maxHeight * 0.02),
                ButtonTheme(
                  minWidth: 500,
                  height: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(300,40),
                        primary: COLOR_DARKPURPLE,
                        shadowColor: Colors.grey.shade50,
                        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                        )
                    ),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      var response = await load_data(myController.text);
                      setState(() {
                        isLoading = false;
                      });
                      if (get_all_recipes_handle(context, response)){
                        setState(() {});
                      }
                      last_text = myController.text;
                      myController.text = "";
                    },
                    child: const Text('Search Recipes'),
                  ),
                ),
                addVerticalSpace(constraints.maxHeight * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Show only my recipes",
                      textScaleFactor: 1.2,
                    ),
                    Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    )
                  ],
                ),
                //addVerticalSpace(constraints.maxHeight * 0.034),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  width: constraints.maxWidth,
                  height: constraints.maxHeight *0.01,
                  decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 2,10),
                ),
                Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: recipes.length,
                      itemBuilder: (context, index){
                        final recipe = recipes[index];
                        return Padding(padding: EdgeInsets.all(5),
                          child: Container(
                              decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 4, 15),
                              child: ListTile(
                                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                                onTap: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  ImageProvider? rImage = await recipesOp.get_recipe_image(recipe.id);
                                  await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RecipeProfileScreen(recipe: recipe, curr_id: curr_id, rImage: rImage,)));
                                  var response = await load_data(last_text);
                                  setState(() {
                                    isLoading = false;
                                  });
                                  if (get_all_recipes_handle(context, response)){
                                    setState(() {});
                                  }
                                },
                                leading: CircleAvatar(
                                  backgroundColor: COLOR_WHITE,
                                  backgroundImage: AssetImage(food_icons[random(0,4)]), // no matter how big it is, it won't overflow
                                ),
                                title: Text(recipe.title),
                                subtitle: Text("${recipe.creator["first_name"]} ${recipe.creator["last_name"]}"),

                              )
                          ),
                        );
                      },
                    )
                ),

              ],),
            myProgressBar(isLoading)
          ],
        );
            }
      ),
    );
  }
}
