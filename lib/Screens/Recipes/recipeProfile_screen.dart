import 'package:cookcal/Screens/home_screen.dart';
import 'package:cookcal/Screens/Login_register/register_screen.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../HTTP/login.dart';
import '../../model/users.dart';
import '../MainNavigation_screen.dart';

class RecipeProfileScreen extends StatefulWidget {
  final Recipe recipe;
  const RecipeProfileScreen({Key? key, required this.recipe}) : super(key: key);
  @override
  _RecipeProfileScreenState createState() => _RecipeProfileScreenState();
}

class _RecipeProfileScreenState extends State<RecipeProfileScreen> {

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
      body: Container(
        color: COLOR_WHITE,
      )
    );
  }
}