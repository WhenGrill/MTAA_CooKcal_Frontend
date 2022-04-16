import 'package:cookcal/model/weight.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/api_const.dart';

class WeightOperations {
  final Dio _dio = Dio();

  Future<List<WeightOut>?> get_all_weight(String date) async {
    try {
      Dio dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['authorization'] = 'Bearer ' + token!;
      Response response = await dio.get(apiURL + '/weight_measurement/?date=' + date);
      print("${response.data}");

      List<WeightOut> weight = List<WeightOut>.from(
          response.data.map((x) => WeightOut.fromJson(x)));
      print("this -> ${weight}");
      return weight;
    }
    catch (e) {
      print(e);
      return null;
    }
  }

}