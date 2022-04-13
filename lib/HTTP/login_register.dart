export '../model/users.dart';

import 'package:cookcal/Utils/api_const.dart';
import 'package:cookcal/model/users.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Userauth with ChangeNotifier{
  final Dio _dio = Dio();

  login(UserLogin logindata) async {
    try {

      Response response = await _dio.post(apiURL + '/login',
                                          data: logindata.toFormData());

      final prefs = await SharedPreferences.getInstance();

      var token = response.data['access_token'];
      await prefs.setString('token', token);
      
      await prefs.setInt('user_id', Jwt.parseJwt(token)['user_id']);

      print(prefs.getString('token'));
      print(prefs.getInt('user_id'));
      /*
      final String? token = shStorage.getString('token');
      print(token);
      */
      return response;
    }
    catch (e) {
      print(e);
    }
  }

  register(UserCreate userData, double curr_weight) async {
    try {
      print(userData.toJson());
      Response response = await _dio.post(apiURL + '/users/',
                                          data: userData.toJson());
      /*print('+++++++++++');
      print(response.data);
      print('++++++++++++');*/
      
      await login(UserLogin(username: userData.email, password: userData.password));
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      _dio.options.headers['authorization'] = 'Bearer ' + token!;
      Response resp_weight = await _dio.post(apiURL + '/weight_measurement/',
      data: {
        'weight': curr_weight
      });
      
      
    }
    catch (e){
      print(e);
    }

  }
}