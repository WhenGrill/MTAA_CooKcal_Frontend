// const apiURL = 'http://10.0.2.2:8000';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

const apiURL = 'http://cookcal.herokuapp.com';


authDio() async {
  Dio d = Dio();
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  d.options.headers['authorization'] = 'Bearer ' + token!;
  return d;
}

Map<String, int> state_of_weight_lodd =
  {
    'Normal': 0,
    'Weight loss': 1,
    'Rapid weight loss': 2
  };