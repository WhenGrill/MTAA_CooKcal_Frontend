import 'package:cookcal/model/food.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/api_const.dart';

class FoodOperations {
  final Dio _dio = Dio();

  get_all_food(String title) async {
    try {
      Dio dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['authorization'] = 'Bearer ' + token!;
      Response response = await dio.get(apiURL + '/food/?title=' + title);

      return response;
    }
    on DioError catch (e) {
      return e.response;
    }
  }

}