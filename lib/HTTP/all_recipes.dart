import 'package:cookcal/model/recipes.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/api_const.dart';

class RecipesOperations {

  Future<List<RecipeOut>?>get_all_recipes(String title) async {
    try {
      Dio dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['authorization'] = 'Bearer ' + token!;
      Response response = await dio.get(apiURL + '/recipes/?title=' + title);
      print("${response.data}");

      List<RecipeOut> recipes = List<RecipeOut>.from(response.data.map((x)=> RecipeOut.fromJson(x)));
      print("this -> ${recipes}");
      return recipes;
    }
    catch (e){
      print(e);
      return null;
    }
  }

}

