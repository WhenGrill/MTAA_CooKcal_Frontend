import 'package:cookcal/HTTP/foodlist_operations.dart';
import 'package:cookcal/HTTP/weight_operations.dart';
import 'package:cookcal/Screens/home_screen.dart';
import 'package:cookcal/Screens/Login_register/register_screen.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:cookcal/model/weight.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../HTTP/login_register.dart';
import '../../model/foodlist.dart';
import '../../model/users.dart';
import '../MainNavigation_screen.dart';
import 'package:cookcal/Widgets/neomoprishm_box.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool _isElevated = false;

  var user_auth = Userauth();
  FoodListOperations foodListOperations = FoodListOperations();
  WeightOperations weightOperations = WeightOperations();

  List<FoodListOut> foods = [];
  List<WeightOut> weights = [];

  load_food_data() async {
    var tmp = await foodListOperations.get_user_foodlist();
    print(tmp);
    print(tmp.runtimeType);
    foods.clear();
    tmp?.forEach((element) {
      foods.add(element);
      print(element.id);
    });
  }

  load_weight_data() async {
    var tmp = await weightOperations.get_all_weight("");
    print(tmp);
    print(tmp.runtimeType);
    weights.clear();
    tmp?.forEach((element) {
      weights.add(element);
      print(element.weight);
    });
  }

  /*
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose(); } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(builder: (context, constraints){
        return Container(
          color: COLOR_WHITE,
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Column(
                    children: [
                      addVerticalSpace(constraints.maxHeight*0.1),
                      Expanded(
                        flex: 8,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(

                            ),
                            Image.asset("assets/images/logo.png"),
                            Padding(padding: const EdgeInsets.all(10)),
                          ],
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.fromLTRB(10,5,10,5),
                          width: constraints.maxWidth,
                          color: COLOR_WHITE,
                          height: constraints.maxHeight * 0.55,

                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 2,10),
                                child: TextField(
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                    icon: Icon(
                                      Icons.local_post_office_outlined,
                                      color: COLOR_DARKPURPLE,
                                    ),
                                    hintText: 'E-mail',
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 2,10),
                                child: TextField(
                                  controller: passController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    icon: Icon(
                                      Icons.key_outlined,
                                      color: COLOR_DARKMINT,
                                    ),
                                    hintText: 'Password',
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                              addVerticalSpace(constraints.maxHeight * 0.1),
                              ButtonTheme(
                                minWidth: 500,
                                height: 200,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: Size(constraints.maxWidth * 0.8,constraints.maxHeight *0.02),
                                      primary: COLOR_DARKPURPLE,
                                      shadowColor: Colors.grey.shade50,
                                      textStyle: const TextStyle(fontSize: 30),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50)
                                      )
                                  ),
                                  onPressed: () async {
                                    var response = await user_auth.login(UserLogin(username: emailController.text, password: passController.text));
                                    if (response != null){

                                      load_food_data();
                                      load_weight_data();

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => MainNavigationScreen(foods: foods, weights: [])),
                                      );
                                    }
                                    else{
                                      showDialog(
                                          context: context,
                                          builder: (context){
                                            return AlertDialog(
                                              shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                              backgroundColor: COLOR_WHITE,
                                              content: Container(
                                                width: constraints.maxWidth * 0.8,
                                                height: constraints.maxHeight * 0.12,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    children: [
                                                      const Text(
                                                        "Invalid E-mail or Password",
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: COLOR_BLACK,
                                                            fontSize: 20
                                                        ),
                                                      ),
                                                      addVerticalSpace(constraints.maxHeight * 0.01),
                                                      SizedBox(
                                                        width: 50,
                                                        height: 50,
                                                        child: FloatingActionButton(
                                                          backgroundColor: COLOR_MINT,
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: const Icon(Icons.arrow_back),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                      );
                                    }
                                  },
                                  child: Text('Login'),
                                ),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(COLOR_DARKMINT),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                                  );
                                },
                                child: Text('or register HERE!',
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            ],
                          )
                      ),
                    ]
                )
        );
      }),
    );
  }
}