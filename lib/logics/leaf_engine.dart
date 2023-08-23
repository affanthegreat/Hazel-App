import 'dart:convert';
import 'package:animated_tree_view/tree_view/tree_node.dart';
import 'package:dio/dio.dart';
import 'package:hazel_client/logics/CommentModels.dart';
import 'package:hazel_client/logics/wrappers.dart';
import 'package:hazel_client/main.dart';
import 'package:hive/hive.dart';

import 'LeafModel.dart';

class LeafEngine {
  final dio = Dio();
  final String url = "http://10.0.2.2:8000/";

  Future<bool> createLeaf(dynamic data) async {
    var apiEndpoint = 'leaf_engine/create_leaf';
    try {
      data['auth_token'] = sessionData!['auth_token'];
      data['token'] = sessionData!['token'];
      final response = await dio.post(url + apiEndpoint, data: data);
      final result = json.decode(response.data);
      if (result['message'] == "Leaf successfully created.") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<Set<LeafModel>> getAllPublicLeaf(int page_number) async {
    var apiEndpoint = 'leaf_engine/get_user_public_leaves';

    var data = {};
    data['auth_token'] = sessionData!['auth_token'];
    data['token'] = sessionData!['token'];
    data['page_number'] = page_number;
    final response = await dio.post(url + apiEndpoint, data: data);
    List<dynamic> result = response.data['data'];
    if (result.isNotEmpty) {
      Set<LeafModel> leaf_qs = {};
      for (int i = 0; i < result.length; i++) {
        var leaf_obj = LeafModel.fromJson(result.elementAt(i));
        leaf_qs.add(leaf_obj);
      }
      return leaf_qs;
    } else {
      return {};
    }
  }

  Future<Set<LeafModel>> getAllPrivateLeaf(int page_number) async {
    var apiEndpoint = 'leaf_engine/get_user_private_leaves';

    var data = {};
    data['auth_token'] = sessionData!['auth_token'];
    data['token'] = sessionData!['token'];
    data['page_number'] = page_number;
    final response = await dio.post(url + apiEndpoint, data: data);
    List<dynamic> result = response.data['data'];
    if (result.isNotEmpty) {
      Set<LeafModel> leaf_qs = {};
      for (int i = 0; i < result.length; i++) {
        var leaf_obj = LeafModel.fromJson(result.elementAt(i));
        leaf_qs.add(leaf_obj);
      }
      return leaf_qs;
    } else {
      return {};
    }
  }

  Future<bool> addView(LeafModel leaf_obj) async {
    var apiEndpoint = 'leaf_engine/add_view';
    var data = {};
    data['auth_token'] = sessionData!['auth_token'];
    data['token'] = sessionData!['token'];
    data['leaf_id'] = leaf_obj.leafId;
    final response = await dio.post(url + apiEndpoint, data: data);
    print(response);
    return true;
  }

  Future<bool> likeLeaf(LeafModel leaf_obj) async {
    try {
      var apiEndpoint = 'leaf_engine/like_leaf';
      var data = {};
      data['auth_token'] = sessionData!['auth_token'];
      data['token'] = sessionData!['token'];
      data['leaf_id'] = leaf_obj.leafId;

      final response = await dio.post(url + apiEndpoint, data: data);
      final result = json.decode(response.data);
      return result == -100;
    } catch (E) {
      throw (E);
      return false;
    }
  }

  Future<bool> dislikeLeaf(LeafModel leaf_obj) async {
    try {
      var apiEndpoint = 'leaf_engine/dislike_leaf';
      var data = {};
      data['auth_token'] = sessionData!['auth_token'];
      data['token'] = sessionData!['token'];
      data['leaf_id'] = leaf_obj.leafId;
      final response = await dio.post(url + apiEndpoint, data: data);
      final result = json.decode(response.data);
      return result == -100;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeLikeLeaf(LeafModel leaf_obj) async {
    try {
      var apiEndpoint = 'leaf_engine/remove_like';
      var data = {};
      data['auth_token'] = sessionData!['auth_token'];
      data['token'] = sessionData!['token'];
      data['leaf_id'] = leaf_obj.leafId;

      final response = await dio.post(url + apiEndpoint, data: data);
      final result = json.decode(response.data);
      return result == -100;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeDisLikeLeaf(LeafModel leaf_obj) async {
    try {
      var apiEndpoint = 'leaf_engine/remove_dislike';
      var data = {};
      data['auth_token'] = sessionData!['auth_token'];
      data['token'] = sessionData!['token'];
      data['leaf_id'] = leaf_obj.leafId;

      final response = await dio.post(url + apiEndpoint, data: data);
      final result = json.decode(response.data);
      return result == -100;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkLike(LeafModel leaf_obj) async {
    try {
      var box = await Hive.openBox('logged-in-user');
      var user_obj = box.get('user_obj');
      var apiEndpoint = 'leaf_engine/check_like';
      var data = {};
      data['user_id'] = user_obj.userId;
      data['leaf_id'] = leaf_obj.leafId;

      final response = await dio.post(url + apiEndpoint, data: data);
      var result = json.decode(response.data);
      return result['message'];
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkDisLike(LeafModel leaf_obj) async {
    try {
      var apiEndpoint = 'leaf_engine/check_dislike';
      var box = await Hive.openBox('logged-in-user');
      var user_obj = box.get('user_obj');
      var data = {};
      data['user_id'] = user_obj.userId;
      data['leaf_id'] = leaf_obj.leafId;
      final response = await dio.post(url + apiEndpoint, data: data);
      var result = json.decode(response.data);
      print(response);
      return result['message'];
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> getAllComments(LeafModel leaf_obj, int page_number) async {

      var apiEndpoint = 'leaf_engine/get_all_comments';
      var data = {};
      data['page_number'] = page_number;
      data['leaf_id'] = leaf_obj.leafId;
      final response = await dio.post(url + apiEndpoint, data: data);
      List<dynamic> result = response.data['data'];

      Map<String, dynamic> comment_set = {};
      List<Map<String, dynamic>> comments = [];
      for(int i= 0; i< result!.length; i++){
        var obj = LeafComments.fromJson(result[i]);
        comments.add(obj.toJson());
        comment_set[obj.commentId!]  = obj;
      }

      final commentTree = constructCommentTree(comments);
      final tree = convertTreeToMap(commentTree);
      CommentsRepo commentsRepo = CommentsRepo();
      commentsRepo.commentsTree = tree;
      commentsRepo.commentsMap = comment_set;
      commentsRepo.sortRootComments();
      return commentsRepo;
  }

  Map<String, Map> convertTreeToMap(List<CommentNode> nodes, {int depth = 0}) {
    Map<String, Map> result = {};

    for (var node in nodes) {
      final comment = node.comment['comment_id'];
      result[comment] = convertTreeToMap(node.children, depth: depth + 1);
    }

    return result;
  }


  Future<dynamic> sendComment(String commentString, LeafModel leaf_obj) async {
    try {
      var apiEndpoint = 'leaf_engine/add_comment';
      var data = {};
      data['comment_string'] = commentString;
      data['leaf_id'] = leaf_obj.leafId;
      data['auth_token'] = sessionData!['auth_token'];
      data['token']  = sessionData!['token'];
      final response = await dio.post(url + apiEndpoint, data: data);
      if(response.data['message'] == -100){
        return true;
      } else{
        return false;
      }
    } catch (e) {
      return false;
    }
  }

}


