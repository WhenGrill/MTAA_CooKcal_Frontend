import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

import 'package:cookcal/Utils/api_const.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/users.dart';

class UsersOperations {

  Future<List<UserOut>?>get_all_users(String name) async {
    try {
      Dio d = Dio();
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var id = prefs.getInt('user_id');
      d.options.headers['authorization'] = 'Bearer ' + token!;
      Response response = await d.get(apiURL + '/users/?name=' + name);
      print(response.data);

      List<UserOut> users = List<UserOut>.from(response.data.map((x)=> UserOut.fromJson(x)));
      users.removeWhere((element) => element.id == id);
      // List<UserOut> users = (response.data).map((e) => UserOut.fromJson(e)).toList();
      print(users);
      return users;
    }
    catch (e){
      print(e);
      return null;
    }
  }



  get_current_user_info() async {
    final prefs = await SharedPreferences.getInstance();
    int id = prefs.getInt('user_id')!;
    UserOneOut u_obj = await get_one_user(id);
    return u_obj;
  }

  get_one_user(int id) async {
    try {
      Dio d = Dio();

      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      d.options.headers['authorization'] = 'Bearer ' + token!;

      Response response = await d.get(apiURL + '/users/' + id.toString());

      UserOneOut user  = UserOneOut.fromJson(response.data);
      print(response.data);
      print(user);

      return user;
    }
    catch (e) {
      print(e);
    }
  }

  get_user_image(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

     ImageProvider img = NetworkImage(apiURL + '/users/' + id.toString() + '/image/',
     headers: {'authorization': 'Bearer ' + token!});

      return img;
    }
    catch (e) {
      print(e);
    }
  }

  upload_user_image() async{
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var id = prefs.getInt('user_id');

    FilePickerResult? pickedImage = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );

    if (pickedImage != null) {
      File file = File(pickedImage.files.single.path!);
      var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length();

      var uri = Uri.parse(apiURL + '/users/' + id.toString() + '/image/');


      var request = http.MultipartRequest('PUT', uri);
      request.headers['authorization'] = 'Bearer ' + token!;

      var multipartFile = http.MultipartFile('prof_picture', stream, length,
          filename: basename(file.path));
      //contentType: new MediaType('image', 'png'));

      request.files.add(multipartFile);
      var response = await request.send();
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });

    } else {
      // User canceled the picker
      print('What do I do here');
    }

  }

  Future<Map<String, dynamic>?>update_user_data(Map<String, dynamic> upUserData) async{
    try {
      Dio d = Dio();
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var id = prefs.getInt('user_id');
      d.options.headers['authorization'] = 'Bearer ' + token!;

      Map<String, dynamic> tmp =  Map<String, dynamic>.from(upUserData);
      for (var x in tmp.entries) {
        if (x.value == null) {
          upUserData.remove(x.key);
        }
      }
      print(upUserData);
      if (upUserData.isNotEmpty) {
        Response response = await d.put(apiURL + '/users/' + id.toString(),
        data: upUserData);
        print(response.statusCode);
        return upUserData;
      }

      return null;
    }
    catch (e){
      print(e);
      return null;
    }
  }

  delete_user_account() async{
    Dio d = Dio();
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var id = prefs.getInt('user_id');
    d.options.headers['authorization'] = 'Bearer ' + token!;
    Response response = await d.delete(apiURL + '/users/' + id.toString());
    print(response.statusCode);
  }

  get_curr_user_id() async {
    final prefs = await SharedPreferences.getInstance();

    int? id = prefs.getInt('user_id');
    return id;
  }

}