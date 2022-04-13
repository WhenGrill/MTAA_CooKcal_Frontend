import 'package:cookcal/Screens/home_screen.dart';
import 'package:cookcal/Screens/Login_register/register_screen.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../HTTP/login_register.dart';
import '../../model/users.dart';
import '../MainNavigation_screen.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({Key? key}) : super(key: key);
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints)
    {
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
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child:  Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            color: COLOR_WHITE,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10,0,10,0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 5,
                      maxLines: null,
                    ),
                  )
                ),
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
                    onPressed: () {},
                    child: const Text('Post Recipe'),
                  ),
                ),
              ],
            ),
          ),
        )
    );
    }
    );
  }
}