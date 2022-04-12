import 'package:cookcal/HTTP/all_recipes.dart';
import 'package:cookcal/Screens/Recipes/recipeProfile_screen.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:flutter/material.dart';
import 'package:cookcal/Widgets/searchBar.dart';

import '../../model/recipes.dart';


class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({Key? key}) : super(key: key);

  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {

  final myController = TextEditingController();

  List<RecipeOut> recipes = [];


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  load_data() async {
    var tmp = await RecipesOperations().get_all_recipes(myController.text);

    print(tmp);
    print(tmp.runtimeType);
    recipes.clear();
    tmp?.forEach((element) {
      recipes.add(element);
      print(element.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(builder: (context, constraints){
        return Column(
          children: [
            addVerticalSpace(constraints.maxHeight * 0.02),
            RoundedSearchInput(
              hintText: 'Search here',
              textController: myController,
            ),
            addVerticalSpace(constraints.maxHeight * 0.02),
            ButtonTheme(
              minWidth: 500,
              height: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300,40),
                    primary: COLOR_GREEN,
                    shadowColor: Colors.grey.shade50,
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                    )
                ),
                onPressed: () async {
                  print(myController.text);
                  await load_data();
                  setState(() {});
                  print('set has been stated');
                },
                child: const Text('Search Recipes'),
              ),
            ),
            addVerticalSpace(constraints.maxHeight * 0.017),
            const Divider(
              color: COLOR_GREEN,
              thickness: 2,
            ),
            Expanded(
                child: ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index){
                    final recipe = recipes[index];
                    return Card(
                        child: ListTile(
                          trailing: const Icon(Icons.arrow_forward_ios_rounded),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RecipeProfileScreen(recipe: recipe)));
                          },
                          leading: CircleAvatar(
                            backgroundColor: COLOR_WHITE,
                            backgroundImage: AssetImage(food_icons[random(0,4)]), // no matter how big it is, it won't overflow
                          ),
                          title: Text(recipe.title),
                          subtitle: Text("${recipe.creator["first_name"]} ${recipe.creator["last_name"]}"),

                        )
                    );
                  },
                )
            )
        ],);
            }
      ),
    );
  }
}
