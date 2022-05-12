import 'dart:convert';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
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

import '../../Utils/api_const.dart';
import '../../WebRTC/utils/AutoReconnectWebSocket.dart';
import '../../Widgets/neomoprishm_box.dart';
import '../../model/recipes.dart';


class RecipeListScreen extends StatefulWidget {
  final int? curr_id;
  const RecipeListScreen({Key? key, required this.curr_id}) : super(key: key);

  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  var ws = AutoReconnectWebSocket(Uri.parse(wbapiURL+ '/recipes/ws'), "Recipes");
  final myController = TextEditingController();
  UsersOperations usersOperations = UsersOperations();
  RecipesOperations recipesOp = RecipesOperations();
  List<RecipeOut> recipes = [];
  late int? curr_id = widget.curr_id;
  String last_text = "";
  bool isChecked = false;
  bool isLoading = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }


  @override
  initState(){
    super.initState();
    myController.addListener(searchControllerListener);
    ws.sink.add(myController.text);
  }

  void searchControllerListener() {
    print(myController.text);
    ws.sink.add(myController.text);
    // ws.startReconnect();
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
    print(isChecked);
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


  ws_load_data(var ws_recipes) async {
    List<RecipeOut> recipes_data = List<RecipeOut>.from(ws_recipes.map((x)=> RecipeOut.fromJson(x)));
    recipes.clear();
    if (isChecked){
      recipes_data.forEach((element) {
        print(element.title);
        if (element.creator['id'] == widget.curr_id) {
          recipes.add(element);
        }
      });
    } else {
      recipes_data.forEach((element) {
        print(element.title);
        String name = element.title.toLowerCase();
        if (name.contains(myController.text.toLowerCase())) {
          recipes.add(element);
          print(element.id);
        }
      });
    }
    print(recipes);
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
                /*ButtonTheme(
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
                ),*/
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
                    child: StreamBuilder(
                      stream: ws.stream,
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

                        if (snapshot.data != null){

                          var data = json.decode(snapshot.data);

                          if (myController.text == ""){
                            APICacheDBModel cacheDBModel = new APICacheDBModel(key: "Recipes", syncData: json.encode(data));
                            APICacheManager().addCacheData(cacheDBModel);
                          }

                          ws_load_data(data['detail']);

                        }
                        return ListView.builder(
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

                                      ImageProvider? rImage = await recipesOp.get_recipe_image(recipe.id);
                                      await failedAPICallsQueue.execute_all_pending();
                                      await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RecipeProfileScreen(recipe: recipe, curr_id: curr_id, rImage: rImage,)));
                                      ws.sink.add(myController.text);

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
