import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hazel_client/main.dart';

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
}