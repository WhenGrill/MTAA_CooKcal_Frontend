import 'package:cookcal/HTTP/foodlist_operations.dart';
import 'package:cookcal/HTTP/weight_operations.dart';
import 'package:cookcal/Screens/Utils_screens/about_screen.dart';
import 'package:cookcal/Screens/home_screen.dart';
import 'package:cookcal/Screens/Login_register/register_screen.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:cookcal/Widgets/mySnackBar.dart';
import 'package:cookcal/model/weight.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      backgroundColor: COLOR_WHITE,
      body: LayoutBuilder(builder: (context, constraints){
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
              child: Column(
                children: [
                  addVerticalSpace(constraints.maxHeight*0.1),
                  Container(
                    width: 250,
                    height: 250,
                    child: Image.asset("assets/images/logo.png"),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 2,10),
                    child: TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'E-mail field is required to login';
                        }
                        else if (!EmailValidator.validate(value)){
                          return 'E-mail format is not correct';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          icon: Icon(
                            Icons.local_post_office_outlined,
                            color: COLOR_PURPLE,
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
                    child: TextFormField(
                      controller: passController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty){
                          return "Password field is required for login";
                        }
                        return null;
                      },
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
                        if (!_formKey.currentState!.validate()){
                          return;
                        }
                        var response = await user_auth.login(UserLogin(username: emailController.text, password: passController.text));
                        if (response == null){

                          mySnackBar(context, Colors.red, COLOR_WHITE, "Something went wrong, check your network status", Icons.close);
                        }
                        else if (response.statusCode == 200){
                          emailController.clear();
                          passController.clear();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MainNavigationScreen()),
                          );
                        }
                        else if (response.statusCode == 403){
                          mySnackBar(context, Colors.red, COLOR_WHITE, "Invalid E-mail or password", Icons.close);
                        }
                        else if (response.statusCode == 422){
                          mySnackBar(context, Colors.red, COLOR_WHITE, "Something went wrong", Icons.close);
                        } else {
                          mySnackBar(context, Colors.red, COLOR_WHITE, "Something went wrong, check your network status", Icons.close);
                        }
                      },
                      child: Text('Login'),
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(COLOR_PURPLE),
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
                  ),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(COLOR_DARKMINT),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AboutScreen()),
                      );
                    },
                    child: Text('About',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              )
          )
        );
      }),
    );
  }
}