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
  const RecipeProfileScreen({Key? key, required this.recipe}) : super(key: key);
  @override
  _RecipeProfileScreenState createState() => _RecipeProfileScreenState();
}

class _RecipeProfileScreenState extends State<RecipeProfileScreen> {
  late RecipeOut recipe = widget.recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        return Container(
          color: COLOR_WHITE,
          child: Column(
            children: [
              addVerticalSpace(10),
              Container(
                width: 220.0,
                height: 220.0,
                decoration: BoxDecoration(
                  color: COLOR_ORANGE,
                  image: DecorationImage(
                    image: AssetImage(food_icons[random(0,4)]),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all( Radius.circular(110.0)),
                  border: Border.all(
                    color: COLOR_ORANGE,
                    width: 5.0,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('${recipe.creator["first_name"]} ${recipe.creator["last_name"]}',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text('${recipe.title}',
                    style: TextStyle(fontSize: 50),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.all(10),
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.15,
                decoration: BoxDecoration(
                  color: COLOR_GREEN,
                  border: Border.all(
                      color: COLOR_ORANGE,
                      width: 3.0),
                  borderRadius: const BorderRadius.all(
                      Radius.circular(10.0)), // set rounded corner radius
                ),
                //child: Text("INFO O MNE", style: TextStyle(color: COLOR_WHITE, fontSize: 50),),
              ),
              Container(
                margin: EdgeInsets.all(10),
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.3,
                decoration: BoxDecoration(
                  color: COLOR_GREEN,
                  border: Border.all(
                      color: COLOR_ORANGE,// set border color
                      width: 3.0),   // set border width
                  borderRadius: const BorderRadius.all(
                      Radius.circular(10.0)), // set rounded corner radius
                ),
                //child: Text("INFO O MNE", style: TextStyle(color: COLOR_WHITE, fontSize: 50),),
              )
            ],
          ),
        );
      }),
    );
  }
}