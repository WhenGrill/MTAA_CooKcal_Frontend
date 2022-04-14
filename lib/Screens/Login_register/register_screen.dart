import 'package:cookcal/Screens/MainNavigation_screen.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:email_validator/email_validator.dart';
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
        return COLOR_MINT;
      }
      return COLOR_DARKPURPLE;
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
                    child: TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email field is required';
                        }
                        else if (!EmailValidator.validate(value)){
                          return 'E-mail format is not correct';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        icon: const Icon(
                          Icons.local_post_office_outlined,
                          color: COLOR_DARKPURPLE,
                        ),
                        hintText: 'Enter your E-mail',
                        focusedBorder: formBorder,
                        errorBorder: formBorder,
                        focusedErrorBorder: formBorder,
                        enabledBorder: formBorder,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: passController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password field is required';
                        }
                        else if (value.length < 6){
                          return 'Password is too short';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        icon: const Icon(
                          Icons.key,
                          color: COLOR_DARKPURPLE,
                        ),
                        hintText: 'Password',
                        focusedBorder: formBorder,
                        errorBorder: formBorder,
                        focusedErrorBorder: formBorder,
                        enabledBorder: formBorder,
                      ),
                    ),
                  ),Container(
                    margin: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: fnameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'First Name field is required';
                        }
                        else if (!RegExp(r'^[A-Za-z]{2,}$').hasMatch(value)){
                          return 'Please enter a valid name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        icon: const Icon(
                          Icons.account_circle_outlined,
                          color: COLOR_DARKPURPLE,
                        ),
                        hintText: 'First Name',
                        focusedBorder: formBorder,
                        errorBorder: formBorder,
                        focusedErrorBorder: formBorder,
                        enabledBorder: formBorder,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: lnameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Last Name field is required';
                        }
                        else if (!RegExp(r'^[A-Za-z]{2,}$').hasMatch(value)){
                          return 'Please enter a valid name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        icon: const Icon(
                          Icons.account_circle_rounded,
                          color: COLOR_DARKPURPLE,
                        ),
                        hintText: 'Last Name',
                        focusedBorder: formBorder,
                        errorBorder: formBorder,
                        focusedErrorBorder: formBorder,
                        enabledBorder: formBorder,
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
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: ageController,
                      validator: (value) {

                        if (value == null || value.isEmpty) {
                          return 'Age field is required';
                        }
                        else if ((!RegExp(r'^[0-9]+$').hasMatch(value)) || (RegExp(r'^[0]+[0-9]*$').hasMatch(value)) || (int.parse(value) < 1)){
                          print("here");
                          return 'Please enter a valid age';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        icon: const Icon(
                          Icons.access_time,
                          color: COLOR_DARKPURPLE,
                        ),
                        hintText: 'Age',
                        focusedBorder: formBorder,
                        errorBorder: formBorder,
                        focusedErrorBorder: formBorder,
                        enabledBorder: formBorder,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: currweightController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Current Weight field is required';
                        }
                        else if (!RegExp(r'^[1-9]+[0-9]*[.]{0,1}[0-9]+$').hasMatch(value) || (double.parse(value) < 5)){
                          return 'Please enter a valid weight';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        icon: const Icon(
                          Icons.restaurant,
                          color: COLOR_DARKPURPLE,
                        ),
                        hintText: 'Current Weight',
                        focusedBorder: formBorder,
                        errorBorder: formBorder,
                        focusedErrorBorder: formBorder,
                        enabledBorder: formBorder,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: goalweightController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Goal Weight field is required';
                        }
                        else if (!RegExp(r'^[1-9]+[0-9]*[.]{0,1}[0-9]+$').hasMatch(value) || (double.parse(value) < 5)){
                          return 'Please enter a valid weight';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        icon: const Icon(
                          Icons.restaurant_menu,
                          color: COLOR_DARKPURPLE,
                        ),
                        hintText: 'Goal Weight',
                        focusedBorder: formBorder,
                        errorBorder: formBorder,
                        focusedErrorBorder: formBorder,
                        enabledBorder: formBorder,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: heightController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Height field is required';
                        }
                        else if (!RegExp(r'^[1-9]+[0-9]*[.]{0,1}[0-9]+$').hasMatch(value) || double.parse(value) < 40 || double.parse(value) > 300){
                          return 'Please enter a valid height';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        icon: const Icon(
                          Icons.accessibility_new_outlined,
                          color: COLOR_DARKPURPLE,
                        ),
                        hintText: 'Height in CM',
                        focusedBorder: formBorder,
                        errorBorder: formBorder,
                        focusedErrorBorder: formBorder,
                        enabledBorder: formBorder,
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
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(260,40),
                          primary: COLOR_DARKPURPLE,
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
                        Provider.of<Userauth>(context, listen: false).register(data, double.parse(currweightController.text));
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                          'Register now!',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                  addVerticalSpace(constraints.maxHeight*0.04)
                ]
            )
            )
        );
      }),
    );
  }
}