import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hazel_client/logics/UserProfileModel.dart';
import 'package:hazel_client/main.dart';
import 'package:hive/hive.dart';

final storage = FlutterSecureStorage();

class UserEngine {
  final dio = Dio();
  final String url = "http://10.0.2.2:8000/";

  Future<bool> checkUserExists(dynamic data) async {
    var apiEndpoint = 'user_engine/check_user_exists';
    try {
      final response = await dio.post(url + apiEndpoint, data: data);
      final result = json.decode(response.data);
      if (result['message'] == "User Does not Exists.") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  Future<bool> createUser(dynamic data) async {
    var apiEndpoint = 'user_engine/create_user';
    try {
      final response = await dio.post(url + apiEndpoint, data: data);
      final result = json.decode(response.data);
      if (result['message'] == "Success") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> login(dynamic data) async {
    var apiEndpoint = 'user_engine/login';
    try {
      final response = await dio.post(url + apiEndpoint, data: data);
      final result = json.decode(response.data);

      if (result['message'] == "Login successful.") {
        await storage.write(key: 'auth_token', value: result['auth_token']);
        await storage.write(key: 'token', value: result['token']);
        sessionData = await storage.readAll();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<UserProfileModel?> fetchUserInfo(bool refresh) async {

      try {
        var apiEndpoint = 'user_engine/get_user_info';
        var getCurrentUser = 'user_engine/current_user';
        var userTokens = {
          'auth_token': sessionData!['auth_token'],
          'token': sessionData!['token']
        };
        print(userTokens);
        final response = await dio.post(url + getCurrentUser, data: userTokens);
        final userName = json.decode(response.data)['user_name'];
        print(userName);
        final userDetailsResponse =
        await dio.post(url + apiEndpoint, data: {'user_name': userName});

        final userProfileObj =
        UserProfileModel.fromJson(json.decode(userDetailsResponse.data));
        print(userProfileObj.userEmail);
        return userProfileObj;
      } catch(e){
        throw e;
        return null;
      }
    }
}
