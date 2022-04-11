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
      appBar: AppBar(
        title: Text('CooKcal'),
        centerTitle: true,
        backgroundColor: COLOR_GREEN,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.settings))
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints){
        return Column(
          children: [
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
                    fixedSize: const Size(150,50),
                    primary: COLOR_GREEN,
                    shadowColor: Colors.grey.shade50,
                    textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                    )
                ),
                onPressed: () {
                  print(myController.text);
                },
                child: Text('Search'),
              ),
            ),
            addVerticalSpace(constraints.maxHeight * 0.02),
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
                          subtitle: Text(recipe.creator),

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
