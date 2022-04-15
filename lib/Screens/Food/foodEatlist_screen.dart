import 'package:cookcal/Screens/Recipes/recipeProfile_screen.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:flutter/material.dart';
import 'package:cookcal/Widgets/searchBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../HTTP/food_operations.dart';
import '../../model/food.dart';


class FoodEatListScreen extends StatefulWidget {
  const FoodEatListScreen({Key? key}) : super(key: key);

  @override
  _FoodEatListScreenState createState() => _FoodEatListScreenState();
}

class _FoodEatListScreenState extends State<FoodEatListScreen> {

  final myController = TextEditingController();
  List<FoodOut> foods = [];
  late int curr_id = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }


  load_data() async {
    var tmp = await FoodOperations().get_all_food(myController.text);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    curr_id = prefs.getInt("user_id")!;
    print(tmp);
    print(tmp.runtimeType);
    foods.clear();
    tmp?.forEach((element) {
      foods.add(element);
      print(element.id);
    });
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
                  await load_data();
                  setState(() {});
                  print('set has been stated');
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
                  itemCount: foods.length,
                  itemBuilder: (context, index){
                    final food = foods[index];
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
                          title: Text(food.title),
                          subtitle: Text("${food.kcal_100g} Kcal / 100g"),

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
