import 'package:cookcal/model/recipes.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

      return response.data;
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
    }
    catch (e){
      print(e);
    }
  }

}