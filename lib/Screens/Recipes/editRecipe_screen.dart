import 'dart:io';

import 'package:cookcal/HTTP/recipes_operations.dart';
import 'package:cookcal/Screens/MainNavigation_screen.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../Widgets/neomoprishm_box.dart';
import '../../model/recipes.dart';

class EditRecipeScreen extends StatefulWidget {
  final RecipeUpdate data;
  final int id;
  const EditRecipeScreen({Key? key, required this.data, required this.id}) : super(key: key);
  @override
  _EditRecipeScreenState createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {

  File? image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late RecipeUpdate data = widget.data;

  late var titleController = TextEditingController(text: data.title);
  late var kcalController = TextEditingController(text: "${data.kcal_100g}");
  late var ingredientsController = TextEditingController(text: data.ingredients);
  late var instructionsController = TextEditingController(text: data.instructions);

  ShowText() {

  }

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
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: COLOR_MINT, //change your color here
            ),
            title: Text('CooKcal', style: TextStyle(color: COLOR_MINT)),
            centerTitle: true,
            backgroundColor: COLOR_VERYDARKPURPLE,
          ),
          body: Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              color: COLOR_WHITE,
              child: SingleChildScrollView(
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
                              child: image != null
                                  ? Image.file(
                                  image!,
                                  fit: BoxFit.cover
                              ): assert_to_image(context, food_icons[random(0, 4)]),
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
                        Padding(
                            padding: EdgeInsets.fromLTRB(15, 7.5, 15, 7.5),
                          child:  Container(
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
                                          else if (!RegExp(r'^[ľščťžýáíéďôäňŕĺóúĽŠČŤŽÝÁÍÉĎÔÄŇŔĹÓÚA-Za-z0-9 ]{2,80}$').hasMatch(value)){
                                            return 'Title too short or too long';
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
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 7.5, 15, 7.5),
                          child:  Container(
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
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 7.5, 15, 7.5),
                          child:  Container(
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
                        ),
                        Container(
                          decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 2, 10),
                          margin: EdgeInsets.fromLTRB(15, 15, 15, 7.5),
                          width: constraints.maxWidth * 0.5,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: kcalController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Kcal/100g field is required';
                              }
                              else if (!RegExp(r'^[1-9]+[0-9]*([.]{1}[0-9]+|)$').hasMatch(value) || (double.parse(value) < 1) || (double.parse(value) > 900)){
                                print("here");
                                return 'Please enter a valid Kcal/100g';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Kcal/100g',
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                border: InputBorder.none
                            ),
                          ),
                        ),
                        addVerticalSpace(12.5),
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
                              Map<String, dynamic> data = {
                                "title": titleController.text,
                                "ingredients": ingredientsController.text,
                                "instructions": instructionsController.text,
                                "kcal_100g": double.parse(kcalController.text)
                                };
                              var response = recipesOperations.UpdateRecipe(data, widget.id);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              final snackBar = SnackBar(backgroundColor: COLOR_DARKMINT,
                                  content: Row(
                                    children: const [
                                      Icon(Icons.check_circle, color: COLOR_WHITE),
                                      SizedBox(width: 20),
                                      Expanded(child: Text('Your recipe has been updated successfully',
                                          style: TextStyle(color: COLOR_WHITE)))
                                    ],
                                  ));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            },
                            child: const Text('Update Recipe'),
                          ),
                        ),
                      addVerticalSpace(35)
                      ],
                    ),
                  )
              )
          )
      );
    }
    );
  }
}