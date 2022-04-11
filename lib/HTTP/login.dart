export '../model/users.dart';

import 'package:cookcal/Utils/api_const.dart';
import 'package:cookcal/model/users.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Userauth with ChangeNotifier{
  final Dio _dio = Dio();

  login(UserLogin logindata) async {
    try {

      var formData = FormData.fromMap(
        {
          'username': logindata.email,
          'password': logindata.password
        }
      );
      print({'email': logindata.email,
        'password': logindata.password});
      Response response = await _dio.post(apiURL+'/login',
                                          data: formData);

      print(response.data);

      final shStorage = await SharedPreferences.getInstance();
      await shStorage.setString('token', response.data['access_token']);
      final String? token = shStorage.getString('token');
      print(token);

      return response.data;
    }
    catch (e) {
      print(e);
    }
  }
}