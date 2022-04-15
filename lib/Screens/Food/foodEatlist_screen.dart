import 'package:cookcal/Screens/Recipes/recipeProfile_screen.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:flutter/material.dart';
import 'package:cookcal/Widgets/searchBar.dart';


class FoodEatListScreen extends StatefulWidget {
  const FoodEatListScreen({Key? key}) : super(key: key);

  @override
  _FoodEatListScreenState createState() => _FoodEatListScreenState();
}

class _FoodEatListScreenState extends State<FoodEatListScreen> {

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_WHITE,
      body: LayoutBuilder(builder: (context, constraints){
        return Column(
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
                  print(myController.text);
                },
                child: const Text('Search Food'),
              ),
            ),
            addVerticalSpace(constraints.maxHeight * 0.02),
            const Divider(
              color: COLOR_DARKPURPLE,
              thickness: 2,
            ),
            Expanded(
                child: ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index){
                    final recipe = recipes[index];
                    return Card(
                        child: ListTile(
                          tileColor: COLOR_WHITE,
                          trailing: const Icon(Icons.arrow_forward_ios_rounded),
                          onTap: () {
                           // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RecipeProfileScreen(recipe: recipe)));
                          },
                          leading: CircleAvatar(
                            backgroundColor: COLOR_WHITE,
                            backgroundImage: AssetImage(food_icons[random(0,4)]), // no matter how big it is, it won't overflow
                          ),
                          title: Text(recipe.title),
                          subtitle: Text(recipe.creator),

                        )
                    );
                  },
                )
              )
            ],
          );
        }
      ),
    );
  }
}
