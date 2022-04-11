import 'package:dio/dio.dart';

class UserCreate {
  final String email;
  final String password;
  final String first_name;
  final String last_name;
  final int gender;
  final int age;
  final double goal_weight;
  final double height;
  final int state;
  final bool is_nutr_adviser;

  UserCreate({
    required this.email,
    required this.password,
    required this.first_name,
    required this.last_name,
    required this.gender,
    required this.age,
    required this.goal_weight,
    required this.height,
    required this.state,
    required this.is_nutr_adviser
  });

  factory UserCreate.fromJson(Map<String, dynamic> json) {
    return UserCreate(
      email: json['email'],
      password: json['password'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      gender: json['gender'],
      age: json['age'],
      goal_weight: json['goal_weight'],
      height: json['height'],
      state: json['state'],
      is_nutr_adviser: json['is_nutr_adviser'],
    );
  }
  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'first_name': first_name,
    'last_name': last_name,
    'gender': gender,
    'age': age,
    'goal_weight': goal_weight,
    'height': height,
    'state': state,
    'is_nutr_adviser': is_nutr_adviser,
  };

  static List<UserCreate> listFromJson(List<dynamic> list) =>
        List<UserCreate>.from(list.map((x) => UserCreate.fromJson(x)));
}

class UserLogin {
  final String username;
  final String password;

  UserLogin({
    required this.username,
    required this.password,
  });

  FormData toFormData() => FormData.fromMap({
      'username': username,
      'password': password,
  });

}

/* GET ALL USERS */
class UserOut {
  final int id;
  final String first_name;
  final String last_name;
  final int gender;
  final int age;
  final int state;
  final bool is_nutr_adviser;

  UserOut({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.gender,
    required this.age,
    required this.state,
    required this.is_nutr_adviser
  });

  factory UserOut.fromJson(Map<String, dynamic> json) {
    return UserOut(
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      gender: json['gender'],
      age: json['age'],
      state: json['state'],
      is_nutr_adviser: json['is_nutr_adviser'],
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': first_name,
    'last_name': last_name,
    'gender': gender,
    'age': age,
    'state': state,
    'is_nutr_adviser': is_nutr_adviser,
  };

  static List<UserOut> listFromJson(List<dynamic> list) =>
      List<UserOut>.from(list.map((x) => UserOut.fromJson(x)));
}