import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/api_const.dart';
import '../model/weight.dart';

class WeightOperations {

  get_all_weight(String date) async {
    try {
      Dio dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['authorization'] = 'Bearer ' + token!;
      Response response = await dio.get(apiURL + '/weight_measurement/?date=' + date);
      return response;

      /*List<WeightOut> weight = List<WeightOut>.from(
          response.data.map((x) => WeightOut.fromJson(x)));*/
    }
    on DioError catch (e) {
      return e.response;
    }
  }

   get_last_weightMeasure(response) {

    List<WeightOut> weight = List<WeightOut>.from(
          response.map((x) => WeightOut.fromJson(x)));

    return weight.last;


  }

  add_weight(double weight) async {
    Dio dio = Dio();
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['authorization'] = 'Bearer ' + token!;

    try {
      Response response = await dio.post(apiURL + '/weight_measurement/', data: {'weight': weight});
      return response;
    }
    on DioError catch (e) {
      failedAPICallsQueue.add({
        'url': apiURL + '/weight_measurement/',
        'token': token,
        'method': 'POST',
        'data': {'weight': weight}
      });
      return e.response;
    }
  }

}