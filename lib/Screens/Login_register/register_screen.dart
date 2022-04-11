import 'package:cookcal/Screens/MainNavigation_screen.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:convert';

import '../../HTTP/login_register.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isChecked = false;
  String valueChose = "Male";
  List genderItems = [
    "Male", "Female", "Other"
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final ageController = TextEditingController();
  final currweightController = TextEditingController();
  final goalweightController = TextEditingController();
  final heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return COLOR_ORANGE;
      }
      return COLOR_GREEN;
    }

    return Scaffold(
      backgroundColor: COLOR_WHITE,
      body: LayoutBuilder(builder: (context, constraints){
        return Form(
          key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  addVerticalSpace(constraints.maxHeight * 0.1),
                  Image.asset(
                      "assets/images/salad.png",
                    height: 330,
                    width: 330,
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    width: 500,
                    height: 63,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                          color: COLOR_ORANGE,// set border color
                          width: 3.0),   // set border width
                      borderRadius: const BorderRadius.all(
                          Radius.circular(10.0)), // set rounded corner radius
                    ),
                    child: TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter something';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.local_post_office_outlined,
                          color: COLOR_GREEN,
                        ),
                        hintText: 'Enter your E-mail',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    width: 500,
                    height: 63,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                          color: COLOR_ORANGE,// set border color
                          width: 3.0),   // set border width
                      borderRadius: const BorderRadius.all(
                          Radius.circular(10.0)), // set rounded corner radius
                    ),
                    child: TextFormField(
                      controller: passController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.key_outlined,
                          color: COLOR_GREEN,
                        ),
                        hintText: 'Password',
                        border: InputBorder.none,
                      ),
                    ),
                  ),Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    width: 500,
                    height: 63,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                          color: COLOR_ORANGE,// set border color
                          width: 3.0),   // set border width
                      borderRadius: const BorderRadius.all(
                          Radius.circular(10.0)), // set rounded corner radius
                    ),
                    child: TextFormField(
                      controller: fnameController,
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.account_circle_outlined,
                          color: COLOR_GREEN,
                        ),
                        hintText: 'First Name',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    width: 500,
                    height: 63,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                          color: COLOR_ORANGE,// set border color
                          width: 3.0),   // set border width
                      borderRadius: const BorderRadius.all(
                          Radius.circular(10.0)), // set rounded corner radius
                    ),
                    child: TextFormField(
                      controller: lnameController,
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.account_circle_rounded,
                          color: COLOR_GREEN,
                        ),
                        hintText: 'Last Name',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Choose a gender:",
                        textScaleFactor: 1.2,
                      ),
                      addHorizontalSpace(15),
                      DropdownButton<String>(
                        alignment: Alignment.center,
                        hint: const Text('Select your gender'),
                        dropdownColor: Colors.grey.shade200,
                        value: valueChose,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black
                        ),
                        items: genderItems.map((valueItem) {
                          return DropdownMenuItem<String>(
                            value: valueItem,
                            child: Text(valueItem),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            valueChose = newValue!;
                          });
                        },
                      ),
                  ]
                ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    width: 500,
                    height: 63,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                          color: COLOR_ORANGE,// set border color
                          width: 3.0),   // set border width
                      borderRadius: const BorderRadius.all(
                          Radius.circular(10.0)), // set rounded corner radius
                    ),
                    child: TextFormField(
                      controller: ageController,
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.access_time,
                          color: COLOR_GREEN,
                        ),
                        hintText: 'Age',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    width: 500,
                    height: 63,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                          color: COLOR_ORANGE,// set border color
                          width: 3.0),   // set border width
                      borderRadius: const BorderRadius.all(
                          Radius.circular(10.0)), // set rounded corner radius
                    ),
                    child: TextFormField(
                      controller: currweightController,
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.restaurant,
                          color: COLOR_GREEN,
                        ),
                        hintText: 'Current Weight',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    width: 500,
                    height: 63,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                          color: COLOR_ORANGE,// set border color
                          width: 3.0),   // set border width
                      borderRadius: const BorderRadius.all(
                          Radius.circular(10.0)), // set rounded corner radius
                    ),
                    child: TextFormField(
                      controller: goalweightController,
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.restaurant_menu,
                          color: COLOR_GREEN,
                        ),
                        hintText: 'Goal Weight',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    width: 500,
                    height: 63,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                          color: COLOR_ORANGE,// set border color
                          width: 3.0),   // set border width
                      borderRadius: const BorderRadius.all(
                          Radius.circular(10.0)), // set rounded corner radius
                    ),
                    child: TextFormField(
                      controller: heightController,
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.accessibility_new_outlined,
                          color: COLOR_GREEN,
                        ),
                        hintText: 'Height in cm',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                        "Are you a nutritonal adviser?",
                      textScaleFactor: 1.2,
                    ),
                    Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    )
                  ],
                ),
                  ButtonTheme(
                    minWidth: 500,
                    height: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(200,80),
                          primary: COLOR_GREEN,
                          shadowColor: Colors.grey.shade50,
                          textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)
                          )
                      ),
                      onPressed: () {
                        if (!_formKey.currentState!.validate()){
                          return;
                        }
                        int gender = 0;
                        bool nutradviser = false;

                        /* GENDER */
                        if (valueChose == 'Female'){
                          gender = 1;
                        }
                        else if (valueChose == 'Other'){
                          gender = 2;
                        }

                        /*NUTR ADVISER*/
                        if (isChecked == true){
                          nutradviser = true;
                        }
                        var data = UserCreate
                          (
                            email: emailController.text,
                            password: passController.text,
                            first_name: fnameController.text,
                            last_name: lnameController.text,
                            gender: gender,
                            age: int.parse(ageController.text),
                            goal_weight: double.parse(goalweightController.text),
                            height: double.parse(heightController.text),
                            state: 0,
                            is_nutr_adviser: nutradviser
                          );
                        Provider.of<Userauth>(context, listen: false).register(data);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: Text('Register'),
                    ),
                  ),
                  addVerticalSpace(constraints.maxHeight*0.05)
                ]
            )
            )
        );
      }),
    );
  }
}