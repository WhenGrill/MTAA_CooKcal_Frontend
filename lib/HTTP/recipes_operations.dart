import 'package:cookcal/model/recipes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'dart:io';

import '../Utils/api_const.dart';

class RecipesOperations {
  final Dio _dio = Dio();

  Future<List<RecipeOut>?> get_all_recipes(String title) async {
    try {
      Dio dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['authorization'] = 'Bearer ' + token!;
      Response response = await dio.get(apiURL + '/recipes/?title=' + title);
      print("${response.data}");

      List<RecipeOut> recipes = List<RecipeOut>.from(
          response.data.map((x) => RecipeOut.fromJson(x)));
      print("this -> ${recipes}");
      return recipes;
    }
    catch (e) {
      print(e);
      return null;
    }
  }

  PostRecipe(RecipeIn recipe) async {

    Dio dio = Dio();
    dio.options.headers['content-type'] = 'application/json';

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers["authorization"] = "Bearer " + token;

    try {

      Response response = await dio.post(apiURL + '/recipes/',
          data: recipe.toJson());

      print(response.data);

      return response;
    }
    catch (e) {
      print(e);
    }
  }

  UpdateRecipe(Map<String, dynamic> upRecipeData, int recipe_id) async{
    try {
      Dio d = Dio();
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      d.options.headers['authorization'] = 'Bearer ' + token!;

      Map<String, dynamic> tmp =  Map<String, dynamic>.from(upRecipeData);
      for (var x in tmp.entries) {
        if (x.value == null) {
          upRecipeData.remove(x.key);
        }
      }
      print(upRecipeData);
      Response response = await d.put(apiURL + '/recipes/' + recipe_id.toString(), data: upRecipeData);
      print(response.statusCode);
      return response;
    }
    catch (e){
      print(e);
    }
  }

  delete_recipe(recipe_id) async {
    Dio d = Dio();
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    d.options.headers['authorization'] = 'Bearer ' + token!;
    Response response = await d.delete(apiURL + '/recipes/' + recipe_id.toString());
    print(response.statusCode);
  }

  get_recipe_image(int? id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      if (id != null) {
        Dio d = Dio();
        d.options.headers['authorization'] = 'Bearer ' + token!;

        Response response = await d.get(apiURL + '/recipes/' + id.toString() + '/image/');
        print(response.statusCode);
        if (response.statusCode != 200){
          return null;
        } else {
          ImageProvider? img = NetworkImage(
              apiURL + '/recipes/' + id.toString() + '/image/',
              headers: {'authorization': 'Bearer ' + token});
          return img;
        }
      } else {
        return null;
      }
    }
    catch (e) {
      return null;
    }
  }

  upload_recipe_image(File pickedImage, int recipe_id) async {
    String filePath = pickedImage.path;

    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var uri = Uri.parse(apiURL + '/recipes/' + recipe_id.toString() + '/image');
    var request = http.MultipartRequest("PUT", uri);
    request.headers['authorization'] = 'Bearer ' + token!;

    request.files.add(http.MultipartFile.fromBytes(
        'recipe_picture',
        await pickedImage.readAsBytes(),
        filename: filePath.split('/').last,
        contentType: MediaType('image', filePath.split('.').last))
    );

    var response = await request.send(); //.then((response) {
    if (response.statusCode == 200)
    {
      print("Uploaded!");
      return 200;
    }
    else
    {
      return null;
    }
    //});
  }

}