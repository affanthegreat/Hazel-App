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
      print(response);
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

  Future<bool> logout() async {
    var apiEndpoint = 'user_engine/logout';
    try {
      var data = {
        'auth_token': sessionData!['auth_token'],
        'token': sessionData!['token']
      };
      final response = await dio.post(url + apiEndpoint, data: data);
      final result = json.decode(response.data);
      print(result);
      if (result['message'] == "Logout successful.") {
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
        final response = await dio.post(url + getCurrentUser, data: userTokens);
        final userName = json.decode(response.data)['user_name'];
        final userDetailsResponse =
        await dio.post(url + apiEndpoint, data: {'user_name': userName});

        print(json.decode(userDetailsResponse.data));
        final userProfileObj =
        UserProfileModel.fromJson(json.decode(userDetailsResponse.data));


        var box = await Hive.openBox('logged-in-user');
        box.put('user_obj',userProfileObj);
        return userProfileObj;
      } catch(e){
        return null;
      }
    }

  Future<List<UserProfileModel?>> searchUserInfo(dynamic data) async {

    try {
      var apiEndpoint = 'user_engine/search_users';
      var userTokens = {
        'page_number': data['page_number'],
        'search_query':  data['search_query'],
        'auth_token': sessionData!['auth_token'],
        'token': sessionData!['token']
      };
      final userDetailsResponse = await dio.post(url + apiEndpoint, data:userTokens);
      List<dynamic> json_data = json.decode(userDetailsResponse.data)['data'];

      var box = await Hive.openBox('logged-in-user');
      var logged_in_user = box.get('user_obj');
      List<UserProfileModel?> userProfilesList = [];
      for(int i= 0; i < json_data.length; i++){
        var userProfileObj = UserProfileModel.fromJson(json_data[i]);
        if(userProfileObj.userId != logged_in_user.userId){
          userProfilesList.add(userProfileObj);
        }
      }
      return userProfilesList;
    } catch(e){
      return [];
    }
  }

  Future<List<UserProfileModel?>> getUserFollowers(dynamic data) async {

    try {
      var apiEndpoint = 'user_engine/get_followers';
      var box = await Hive.openBox('logged-in-user');
      var user_obj = box.get('user_obj');
      var userTokens = {
        'page_number': data['page_number'],
        'user_id': user_obj.userId
      };
      final userDetailsResponse = await dio.post(url + apiEndpoint, data:userTokens);
      List<dynamic> json_data = json.decode(userDetailsResponse.data)['data'];
      print(json_data);
      List<UserProfileModel?> userProfilesList = [];
      for(int i= 0; i < json_data.length; i++){
        var userProfileObj = UserProfileModel.fromJson(json_data[i]);
        print(userProfileObj.userName);
        userProfilesList.add(userProfileObj);
      }
      return userProfilesList;

    } catch(e){
      return [];
    }
  }

  Future<List<UserProfileModel?>> getUserFollowing(dynamic data) async {
    try {
      var apiEndpoint = 'user_engine/get_following';
      var box = await Hive.openBox('logged-in-user');
      var user_obj = box.get('user_obj');
      var userTokens = {
        'page_number': data['page_number'],
        'user_id': user_obj.userId
      };
      final userDetailsResponse = await dio.post(
          url + apiEndpoint, data: userTokens);
      List<dynamic> json_data =userDetailsResponse.data['data'];
      print("||||||||||||||||");
      print(json_data);

      List<UserProfileModel?> userProfilesList = [];
      for (int i = 0; i < json_data.length; i++) {
        print("in for loop");
        var userProfileObj = UserProfileModel.fromJson(json_data[i]);
        userProfilesList.add(userProfileObj);
      }
      return userProfilesList;
    } catch (e) {
      print(e);
      throw(e);
      return [];
    }
  }

  Future<dynamic> getFollowingStatus(dynamic data) async {
    try {
      var apiEndpoint = 'user_engine/check_follow';
      var box = await Hive.openBox('logged-in-user');
      var user_obj = box.get('user_obj');
      var userTokens = {
        'search_profile_id': data['search_profile_id'],
        'user_id': user_obj.userId
      };
      final follow_response = await dio.post(
          url + apiEndpoint, data: userTokens);
      print(follow_response);
      data = json.decode(follow_response.data);
      print(data);
      return data;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> createFollowRequest(dynamic data) async {
    try {
      var apiEndpoint = 'user_engine/make_follow_request_view';
      var userTokens = {
        'requested_to': data['requested_to'],
        'auth_token': sessionData!['auth_token'],
        'token': sessionData!['token']
      };
      final response = await dio.post(
          url + apiEndpoint, data: userTokens);
      data = json.decode(response.data);
      print(data);
      return data;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> removeFollowRequest(dynamic data) async {
    try {
      var apiEndpoint = 'user_engine/remove_follow_request_view';
      var userTokens = {
        'requested_to': data['requested_to'],
        'auth_token': sessionData!['auth_token'],
        'token': sessionData!['token']
      };
      final response = await dio.post(
          url + apiEndpoint, data: userTokens);
      data = json.decode(response.data);
      print(data);
      return data;
    } catch (e) {
      return false;
    }
  }

  Future<List<UserProfileModel?>> getFollowRequests(dynamic data) async {
    try {
      var apiEndpoint = 'user_engine/fetch_all_follow_request_view';
      var box = await Hive.openBox('logged-in-user');
      var user_obj = box.get('user_obj');
      var userTokens = {
        'page_number': data['page_number'],
        'user_id': user_obj.userId
      };
      final userDetailsResponse = await dio.post(
          url + apiEndpoint, data: userTokens);
      List<dynamic> json_data = json.decode(userDetailsResponse.data)['data'];
      List<UserProfileModel?> userProfilesList = [];
      for (int i = 0; i < json_data.length; i++) {
        var userProfileObj = UserProfileModel.fromJson(json_data[i]);
        print(userProfileObj.userName);
        userProfilesList.add(userProfileObj);
      }
      return userProfilesList;
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> acceptFollowRequest(dynamic data) async {
    try {
      var apiEndpoint = 'user_engine/accept_follow_request';
      var userTokens = {
        'user_id': data['requested_to'],
        'auth_token': sessionData!['auth_token'],
        'token': sessionData!['token']
      };
      final response = await dio.post(
          url + apiEndpoint, data: userTokens);
      data = json.decode(response.data);
      print("=========================");
      print(data);
      return data;
    } catch (e) {
      return false;
    }
  }

}

