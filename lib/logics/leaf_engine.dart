import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hazel_client/main.dart';

import 'LeafModel.dart';

class LeafEngine{
   final dio = Dio();
   final String url = "http://10.0.2.2:8000/";

   Future<bool> createLeaf(dynamic data) async{
      var apiEndpoint = 'leaf_engine/create_leaf';
      try {
         data['auth_token'] = sessionData!['auth_token'];
         data['token'] = sessionData!['token'];
         final response = await dio.post(url + apiEndpoint, data: data);
         final result = json.decode(response.data);
         print(result);
         if (result['message'] == "Leaf successfully created.") {
            return true;
         } else {
            return false;
         }
      } catch (e) {
         return false;
      }
   }
   Future<Set<LeafModel>> getAllPublicLeaf(int page_number) async{
      var apiEndpoint = 'leaf_engine/get_user_public_leaves';

         var data = {};
         data['auth_token'] = sessionData!['auth_token'];
         data['token'] = sessionData!['token'];
         data['page_number'] = page_number;
         final response = await dio.post(url + apiEndpoint, data: data);
         print("Private");
         List<dynamic> result = response.data['data'];
         if(result.isNotEmpty){
            Set<LeafModel> leaf_qs = {};
            for(int i=0; i< result.length; i++){
               var leaf_obj = LeafModel.fromJson(result.elementAt(i));
               print(leaf_obj.textContent);
               leaf_qs.add(leaf_obj);
            }
            print("=++++++=");
            print(leaf_qs);
            return leaf_qs;
         } else{
            return {};
         }
   }

   Future<Set<LeafModel>> getAllPrivateLeaf(int page_number) async{
      var apiEndpoint = 'leaf_engine/get_user_private_leaves';

         var data = {};
         data['auth_token'] = sessionData!['auth_token'];
         data['token'] = sessionData!['token'];
         data['page_number'] = page_number;
         final response = await dio.post(url + apiEndpoint, data: data);
         print("Private");
         List<dynamic> result = response.data['data'];
         if(result.isNotEmpty){
            Set<LeafModel> leaf_qs = {};
            for(int i=0; i< result.length; i++){
               var leaf_obj = LeafModel.fromJson(result.elementAt(i));
               print(leaf_obj.textContent);
               leaf_qs.add(leaf_obj);
            }
            print("=||||||||||=");
            print(leaf_qs);
            return leaf_qs;
         } else{
            return {};
         }

   }


   Future<bool> addView(LeafModel leaf_obj) async{
      var apiEndpoint = 'leaf_engine/add_view';
      var data = {};
      data['auth_token'] = sessionData!['auth_token'];
      data['token'] = sessionData!['token'];
      data['leaf_id'] = leaf_obj.leafId;
      final response = await dio.post(url + apiEndpoint, data: data);
      print(response);
      return true;
   }


   Future<bool> likeLeaf(LeafModel leaf_obj) async{
      var apiEndpoint = 'leaf_engine/like_leaf';
      var data = {};
      data['auth_token'] = sessionData!['auth_token'];
      data['token'] = sessionData!['token'];
      data['leaf_id'] = leaf_obj.leafId;

      final response = await dio.post(url + apiEndpoint, data: data);
      print(response);
      return true;
   }

   Future<bool> dislikeLeaf(LeafModel leaf_obj) async{
      var apiEndpoint = 'leaf_engine/dislike_leaf';
      var data = {};
      data['auth_token'] = sessionData!['auth_token'];
      data['token'] = sessionData!['token'];
      data['leaf_id'] = leaf_obj.leafId;

      final response = await dio.post(url + apiEndpoint, data: data);
      print(response);
      return true;
   }

   Future<bool> removeLikeLeaf(LeafModel leaf_obj) async{
      var apiEndpoint = 'leaf_engine/remove_like';
      var data = {};
      data['auth_token'] = sessionData!['auth_token'];
      data['token'] = sessionData!['token'];
      data['leaf_id'] = leaf_obj.leafId;

      final response = await dio.post(url + apiEndpoint, data: data);
      print(response);
      return true;
   }

   Future<bool> removeDisLikeLeaf(LeafModel leaf_obj) async{
      var apiEndpoint = 'leaf_engine/remove_dislike';
      var data = {};
      data['auth_token'] = sessionData!['auth_token'];
      data['token'] = sessionData!['token'];
      data['leaf_id'] = leaf_obj.leafId;

      final response = await dio.post(url + apiEndpoint, data: data);
      print(response);
      return true;
   }

   Future<bool> checkLike(LeafModel leaf_obj) async{
      var apiEndpoint = 'leaf_engine/check_like';
      var data = {};
      data['auth_token'] = sessionData!['auth_token'];
      data['token'] = sessionData!['token'];
      data['leaf_id'] = leaf_obj.leafId;

      final response = await dio.post(url + apiEndpoint, data: data);
      print(response);
      return true;
   }

   Future<bool> checkDisLike(LeafModel leaf_obj) async{
      var apiEndpoint = 'leaf_engine/check_dislike';
      var data = {};
      data['auth_token'] = sessionData!['auth_token'];
      data['token'] = sessionData!['token'];
      data['leaf_id'] = leaf_obj.leafId;

      final response = await dio.post(url + apiEndpoint, data: data);
      print(response);
      return true;
   }
}