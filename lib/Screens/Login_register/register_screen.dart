import 'package:cookcal/Screens/MainNavigation_screen.dart';
import 'package:cookcal/Status_code_handling/status_code_handling.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:cookcal/Widgets/mySnackBar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:convert';

import '../../HTTP/login_register.dart';
import '../../Widgets/neomoprishm_box.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isChecked = false;
  String valueChose = "Male";
  Userauth userauth = Userauth();

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
                      "assets/images/logo.png",
                    height: 300,
                    width: 300,
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 2,10),
                    child: TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'E-mail field is required';
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
                        hintText: 'Enter your E-mail',
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 2,10),
                    child: TextFormField(
                      controller: passController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password field is required';
                        }
                        else if (value.length < 6){
                          return 'Password is too short';
                        }
                        else if (RegExp(r'^.*[ \n\t]+.*$').hasMatch(value)){
                          return 'Password can not have blank space characters';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.key,
                          color: COLOR_PURPLE,
                        ),
                        hintText: 'Password',
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none
                      ),
                    ),
                  ),Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 2,10),
                    child: TextFormField(
                      controller: fnameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'First Name field is required';
                        }
                        else if (!RegExp(r'^[ľščťžýáíéďôäňŕĺóúĽŠČŤŽÝÁÍÉĎÔÄŇŔĹÓÚA-Za-z0-9]{2,50}$').hasMatch(value)){
                          return 'Please enter a valid name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.account_circle_outlined,
                          color: COLOR_PURPLE,
                        ),
                        hintText: 'First Name',
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 2,10),
                    child: TextFormField(
                      controller: lnameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Last Name field is required';
                        }
                        else if (!RegExp(r'^[ľščťžýáíéďôäňŕĺóúĽŠČŤŽÝÁÍÉĎÔÄŇŔĹÓÚA-Za-z0-9]{2,50}$').hasMatch(value)){
                          return 'Please enter a valid name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.account_circle_rounded,
                          color: COLOR_PURPLE,
                        ),
                        hintText: 'Last Name',
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none
                      ),
                    ),
                  ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Choose a gender:",
                        style: TextStyle(
                            color: COLOR_DARKPURPLE,
                          fontSize: 17
                        ),
                      ),
                      addHorizontalSpace(15),
                      DropdownButton<String>(
                        alignment: Alignment.center,
                        hint: const Text('Select your gender'),
                        dropdownColor: COLOR_WHITE,
                        focusColor: COLOR_WHITE,
                        value: valueChose,
                        style: const TextStyle(
                            fontSize: 20,
                            color: COLOR_PURPLE
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
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 2,10),
                    child: TextFormField(
                      controller: ageController,
                      validator: (value) {

                        if (value == null || value.isEmpty) {
                          return 'Age field is required';
                        }
                        else if ((!RegExp(r'^[1-9]+[0-9]*$').hasMatch(value)) || !(int.parse(value) < 120)){
                          return 'Please enter a valid age';
                        }
                        else if ((int.parse(value) < 10)){
                          return 'Age requirements do not met (at least 10 years old)';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.access_time,
                          color: COLOR_PURPLE,
                        ),
                        hintText: 'Age',
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 2,10),
                    child: TextFormField(
                      controller: currweightController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Current Weight field is required';
                        }
                        else if (!RegExp(r'^[1-9]+[0-9]*([.]{1}[0-9]+|)$').hasMatch(value) || (double.parse(value) < 5) || (double.parse(value)>700)){
                          return 'Please enter a valid weight';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.restaurant,
                          color: COLOR_PURPLE,
                        ),
                        hintText: 'Current Weight in Kg',
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 2,10),
                    child: TextFormField(
                      controller: goalweightController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Goal Weight field is required';
                        }
                        else if (!RegExp(r'^[1-9]+[0-9]*([.]{1}[0-9]+|)$').hasMatch(value) || (double.parse(value) < 5) || (double.parse(value)>700)){
                          return 'Please enter a valid weight';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.restaurant_menu,
                          color: COLOR_PURPLE,
                        ),
                        hintText: 'Goal Weight in Kg',
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 2,10),
                    child: TextFormField(
                      controller: heightController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Height field is required';
                        }
                        else if (!RegExp(r'^[1-9]+[0-9]*([.]{1}[0-9]+|)$').hasMatch(value) || double.parse(value) < 30 || double.parse(value) > 300){
                          return 'Please enter a valid height';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.accessibility_new_outlined,
                          color: COLOR_PURPLE,
                        ),
                        hintText: 'Height in CM',
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none
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
                      style: TextStyle(
                        color: COLOR_PURPLE
                      ),
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
                      onPressed: () async {
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
                        var response = await userauth.register(data, double.parse(currweightController.text));

                        if (response == null) {
                          mySnackBar(
                              context, Colors.red, COLOR_WHITE, unknowError,
                              Icons.close);
                        }else if (response.statusCode == 201){
                          mySnackBar(context, COLOR_DARKMINT, COLOR_WHITE, "Successfully registered! You can now login", Icons.check);
                          Navigator.pop(context);
                        } else if (response.statusCode == 400){
                          mySnackBar(context, Colors.red, COLOR_WHITE, "E-mail already taken", Icons.close);
                        } else {
                          mySnackBar(context, Colors.red, COLOR_WHITE, unknowError, Icons.close);
                        }


                      },
                      child: const Text(
                          'Register now!',
                        style: TextStyle(
                          fontSize: 20,
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