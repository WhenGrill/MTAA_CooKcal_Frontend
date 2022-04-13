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
        body: Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          color: COLOR_WHITE,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: constraints.maxWidth,
                      height: 220.0,
                      decoration: BoxDecoration(
                        color: COLOR_ORANGE,
                        image: DecorationImage(
                          image: AssetImage(food_icons[random(0,4)]),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        border: Border.all(
                          color: COLOR_GREEN,
                          width: 5.0,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 7,
                                blurRadius: 7,
                                offset: Offset(3, 5),
                              ),
                            ],
                          ),
                          child: FloatingActionButton(
                            onPressed: () {},
                            backgroundColor: COLOR_ORANGE,
                            child: Icon(Icons.photo),
                          ),
                        ),
                    )
                  ],
                ),
                Card(
                    child: Container(
                        margin: EdgeInsets.fromLTRB(10,10,10,10),
                        child: Column(
                          children: const [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Ingredients",
                                style: TextStyle(
                                  fontSize: 23,
                                ),
                              ),
                            ),
                            TextField(
                              keyboardType: TextInputType.multiline,
                              minLines: 3,
                              maxLines: null,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: COLOR_GREEN, width: 2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: COLOR_ORANGE, width: 2),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: COLOR_GREEN, width: 2),
                                  ),
                                )
                            ),
                          ],
                        )
                    )
                ),
                Card(
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(10,10,10,10),
                        child: Column(
                          children: const [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Instructions",
                                style: TextStyle(
                                  fontSize: 23,
                                ),
                              ),
                            ),
                            TextField(
                              keyboardType: TextInputType.multiline,
                              minLines: 7,
                              maxLines: null,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: COLOR_GREEN, width: 2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: COLOR_ORANGE, width: 2),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: COLOR_GREEN, width: 2),
                                  ),
                                )
                            ),
                          ],
                        )
                    )
                ),
                addVerticalSpace(15),
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
          )
        )
        );
    }
    );
  }
}