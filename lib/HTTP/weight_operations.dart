import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/api_const.dart';
import '../model/weight.dart';

class WeightOperations {

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

  Future<WeightOut?> get_last_weightMeasure() async {
    try {
      List<WeightOut>? weights = await get_all_weight('');

      if (weights == null){
        return null;
      }
      return weights.last;

    }
    catch (e) {
      print(e);
      return null;
    }
  }

  add_weight(double weight) async {
    try {
      Dio dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['authorization'] = 'Bearer ' + token!;
      Response response = await dio.post(apiURL + '/weight_measurement/', data: {'weight': weight});
      print(response.statusCode);
    }
    catch (e) {
      print(e);
      return null;
    }
  }

}