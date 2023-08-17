import 'dart:convert';

import 'package:dio/dio.dart';
final dio = Dio();

class UserEngine {
  static final String url = "http://10.0.2.2:8000/";
  static Future<bool> checkUserExists(dynamic data) async{
    var apiEndpoint = 'user_engine/check_user_exists';
    try {
      final response = await dio.post(url + apiEndpoint, data: data);
      print(response);
      final result = json.decode(response.data);

      if (result['message'] == "User Does not Exists.") {
        return true;
      }
      else{
        return false;
      }
    } catch(e){
      return false;
    }
  }
  static bool validateStructure(String value){
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

}