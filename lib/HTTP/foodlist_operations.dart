import 'package:cookcal/model/foodlist.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/api_const.dart';

class FoodListOperations {
  final Dio _dio = Dio();

  PostRecipe(FoodlistIn food) async {

    Dio dio = Dio();
    dio.options.headers['content-type'] = 'application/json';

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers["authorization"] = "Bearer " + token;

    try {

      Response response = await dio.post(apiURL + '/foodlist/',
          data: food.toJson());

      print(response.data);

      return response.data;
    }
    catch (e) {
      print(e);
    }
  }

}