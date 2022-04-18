import 'dart:io';

import 'package:cookcal/HTTP/recipes_operations.dart';
import 'package:cookcal/Screens/home_screen.dart';
import 'package:cookcal/Screens/Login_register/register_screen.dart';
import 'package:cookcal/Status_code_handling/status_code_handling.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:cookcal/Widgets/mySnackBar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../HTTP/login_register.dart';
import '../../Widgets/neomoprishm_box.dart';
import '../../model/recipes.dart';
import '../../model/users.dart';
import '../MainNavigation_screen.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({Key? key}) : super(key: key);
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  
  File? image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final kcalController = TextEditingController();
  final ingredientsController = TextEditingController();
  final instructionsController = TextEditingController();

  late RecipesOperations recipesOperations = RecipesOperations();

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print("failed to pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints)
    {
      return Scaffold(
        backgroundColor: COLOR_WHITE,
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
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
                          color: COLOR_VERYDARKPURPLE,
                          borderRadius: const BorderRadius.all(Radius.circular(0)),
                          border: Border.all(
                            color: COLOR_DARKPURPLE,
                            width: 5.0,
                          ),
                        ),
                        child: image != null ? Image.file(image!, fit: BoxFit.cover): assert_to_image(context, food_icons[random(0, 4)]),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(180)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 7,
                                blurRadius: 7,
                                offset: const Offset(3, 5),
                              ),
                            ],
                          ),
                          child: FloatingActionButton(
                            onPressed: () => pickImage(),
                            backgroundColor: COLOR_MINT,
                            child: Icon(Icons.photo),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 15, 15, 7.5),
                    decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 4, 20),
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(10,10,10,10),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Title",
                                style: TextStyle(
                                  fontSize: 23,
                                ),
                              ),
                            ),
                            TextFormField(
                                controller: titleController,
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: null,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Title field is required';
                                  }
                                  else if (!RegExp(r'^[ľščťžýáíéďôäňŕĺóúĽŠČŤŽÝÁÍÉĎÔÄŇŔĹÓÚA-Za-z0-9 \n\t]{2,80}$').hasMatch(value)){
                                    return 'Special characters are not allowed in recipe title';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    border: InputBorder.none
                                )
                            ),
                          ],
                        )
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 15, 15, 7.5),
                    decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 4, 20),
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(10,10,10,10),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Ingredients",
                                style: TextStyle(
                                  fontSize: 23,
                                ),
                              ),
                            ),
                            TextFormField(
                                controller: ingredientsController,
                                keyboardType: TextInputType.multiline,
                                minLines: 3,
                                maxLines: null,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Ingredients field is required';
                                  }
                                  else if (value.length < 10){
                                    return 'Please enter at least 10 characters';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    border: InputBorder.none
                                )
                            ),
                          ],
                        )
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(15, 15, 15, 7.5),
                      decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 4, 20),
                      child: Container(
                          margin: const EdgeInsets.fromLTRB(10,10,10,10),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Instructions",
                                  style: TextStyle(
                                    fontSize: 23,
                                  ),
                                ),
                              ),
                              TextFormField(
                                  controller: instructionsController,
                                  keyboardType: TextInputType.multiline,
                                  minLines: 7,
                                  maxLines: null,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Instruction field is required';
                                    }
                                    else if (value.length < 10){
                                      return 'Please enter at least 10 characters';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      border: InputBorder.none
                                  )
                              ),
                            ],
                          )
                      )
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 2, 10),
                    width: constraints.maxWidth * 0.5,
                    child: TextFormField(
                      controller: kcalController,
                      textAlign: TextAlign.center,
                      maxLength: 10,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kcal/100g field is required';
                        }
                        else if (!RegExp(r'^[1-9]+[0-9]*([.]{1}[0-9]+|)$').hasMatch(value) || (double.parse(value) <= 1) || (double.parse(value) > 900)){
                          print("here");
                          return 'Please enter a valid Kcal/100g';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        counterText: "",
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                          hintText: "Kcal / 100g"
                      ),
                    ),
                  ),
                  addVerticalSpace(5),
                  ButtonTheme(
                    minWidth: 500,
                    height: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(300,40),
                          primary: COLOR_DARKPURPLE,
                          shadowColor: Colors.grey.shade50,
                          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)
                          )
                      ),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()){
                          return;
                        }
                        RecipeIn data = RecipeIn(
                          title: titleController.text,
                          ingredients: ingredientsController.text,
                          instructions: instructionsController.text,
                          kcal_100g: double.parse(kcalController.text),
                        );
                        Response? response = await recipesOperations.PostRecipe(data);

                        if(response != null) {
                          if (response.statusCode == 201 && image != null) {
                            int recipe_id = response.data['id'];
                            http.StreamedResponse? img_response = await recipesOperations.upload_recipe_image(image!, recipe_id);
                            await image_handle(context, img_response, this);

                            if (image == null) {
                              mySnackBar(context, COLOR_DARKMINT, COLOR_WHITE,
                                  'Recipe successfully uploaded but without image :( (If you wish to upload image please do in recipe edit screen)',
                                  Icons.check_circle);
                            } else {
                              mySnackBar(context, COLOR_DARKMINT,COLOR_WHITE, 'Recipe successfully uploaded.', Icons.check_circle);
                            }
                          } else if (response.statusCode == 201){
                            mySnackBar(context, COLOR_DARKMINT,COLOR_WHITE, 'Recipe successfully uploaded.', Icons.check_circle);
                          } else if (response.statusCode == 401){
                            mySnackBar(context, Colors.red,COLOR_WHITE, loginEx, Icons.close);
                            Navigator.pop(context);
                          }else{
                            mySnackBar(context, COLOR_DARKMINT,COLOR_WHITE, unknowError, Icons.cloud_off_rounded);
                          }
                        } else{
                          mySnackBar(context, COLOR_DARKMINT,COLOR_WHITE, unknowError, Icons.cloud_off_rounded);
                        }

                        titleController.text = "";
                        ingredientsController.text = "";
                        instructionsController.text = "";
                        kcalController.text = "";
                        image = null;
                        setState(() {
                        });


                      },
                      child: const Text('Upload Recipe'),
                    ),
                  ),
                  addVerticalSpace(constraints.maxHeight * 0.07)
                ],
              ),
            )
        )
        );
    }
    );
  }
}