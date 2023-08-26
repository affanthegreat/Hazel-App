import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hazel_client/logics/CommentModels.dart';
import 'package:hazel_client/logics/user_engine.dart';
import 'package:hazel_client/logics/wrappers.dart';
import 'package:hazel_client/main.dart';
import 'package:hive/hive.dart';

import 'LeafModel.dart';

class LeafEngine {
  final dio = Dio();
  final String url = "http://10.0.2.2:8000/";


  List<String> getAllMentions(String text) {
    final regexp = RegExp(r'\@[a-zA-Z0-9]+\b()');

    List<String> mentions = [];

    regexp.allMatches(text).forEach((element) {
      if (element.group(0) != null) {
        mentions.add(element.group(0).toString());
      }
    });

    return mentions;
  }


  Future<bool> checkValidMentions(String txt) async {
    var mentions = getAllMentions(txt);
    for(var i in mentions){
        print(i.substring(1,i.length));
        var status = await UserEngine().checkUserExists({'user_name': i.substring(1,i.length)});
        if(status){
          return false;
        }
    }
    return true;
  }
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


  Future<CommentsRepo> getTopComments(LeafModel leaf_obj) async {
    try{
      var apiEndpoint = 'leaf_engine/get_top_comments';
      var data = {};
      data['leaf_id'] = leaf_obj.leafId;
      final response = await dio.post(url + apiEndpoint, data: data);
      List<dynamic> result = response.data['data'];
      print("________________________");
      print(result);
      Map<String, dynamic> comment_set = {};
      List<Map<String, dynamic>> comments = [];
      Map<String, dynamic> comment_users = {};


      for(int i= 0; i< result.length; i++){
        var obj = LeafComments.fromJson(result[i]);
        comments.add(obj.toJson());
        comment_set[obj.commentId!]  = obj;
        var user_obj_ = await userEngineObj.fetchUserInfoId(obj.commentedById!);
        comment_users[obj.commentId!] = user_obj_;
      }
      final commentTree = constructCommentTree(comments);
      final tree = convertTreeToMap(commentTree);

      CommentsRepo commentsRepo = CommentsRepo();
      commentsRepo.commentsTree = tree;
      commentsRepo.commentsMap = comment_set;
      commentsRepo.commentUsers = comment_users;
      return commentsRepo;
    } catch(e) {
      return CommentsRepo();
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
        leaf_obj.topComments = await getTopComments(leaf_obj);
        print(leaf_obj!.topComments!.commentsTree!);
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
        leaf_obj.topComments = await getTopComments(leaf_obj);
        leaf_qs.add(leaf_obj);
      }
      return leaf_qs;
    } else {
      return {};
    }
  }

  Future<Set<LeafModel>> getLeaves(String userId, int page_number) async {
    var apiEndpoint = 'leaf_engine/get_leaves';

    var data = {};
    data['auth_token'] = sessionData!['auth_token'];
    data['token'] = sessionData!['token'];
    data['page_number'] = page_number;
    data['user_id'] = userId;
    final response = await dio.post(url + apiEndpoint, data: data);
    print(response.data);
    List<dynamic?> result = response.data['data'];
    if (result.isNotEmpty) {
      Set<LeafModel> leaf_qs = {};
      for (int i = 0; i < result.length; i++) {
        var leaf_obj = LeafModel.fromJson(result.elementAt(i));
        leaf_obj.topComments = await getTopComments(leaf_obj);
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
    return true;
  }

  Future<int> likeLeaf(LeafModel leaf_obj) async {
    try {
      var apiEndpoint = 'leaf_engine/like_leaf';
      var data = {};
      data['auth_token'] = sessionData!['auth_token'];
      data['token'] = sessionData!['token'];
      data['leaf_id'] = leaf_obj.leafId;

      final response = await dio.post(url + apiEndpoint, data: data);
      final result = json.decode(response.data);
      return result;
    } catch (E) {
      return -111;
    }
  }

  Future<int> dislikeLeaf(LeafModel leaf_obj) async {

      var apiEndpoint = 'leaf_engine/dislike_leaf';
      var data = {};
      data['auth_token'] = sessionData!['auth_token'];
      data['token'] = sessionData!['token'];
      data['leaf_id'] = leaf_obj.leafId;
      final response = await dio.post(url + apiEndpoint, data: data);
      final result = json.decode(response.data);
      return result;

  }

  Future<int> removeLikeLeaf(LeafModel leaf_obj) async {
    try {
      var apiEndpoint = 'leaf_engine/remove_like';
      var data = {};
      data['auth_token'] = sessionData!['auth_token'];
      data['token'] = sessionData!['token'];
      data['leaf_id'] = leaf_obj.leafId;

      final response = await dio.post(url + apiEndpoint, data: data);
      final result = json.decode(response.data);
      return result;
    } catch (e) {
      return -112;
    }
  }

  Future<int> removeDisLikeLeaf(LeafModel leaf_obj) async {
    try {
      var apiEndpoint = 'leaf_engine/remove_dislike';
      var data = {};
      data['auth_token'] = sessionData!['auth_token'];
      data['token'] = sessionData!['token'];
      data['leaf_id'] = leaf_obj.leafId;

      final response = await dio.post(url + apiEndpoint, data: data);
      final result = json.decode(response.data);
      return result;
    } catch (e) {
      return -111;
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
      return result;
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
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<CommentsRepo> getAllComments(LeafModel leaf_obj, int page_number) async {
      try{
        var apiEndpoint = 'leaf_engine/get_all_comments';
        var data = {};
        data['page_number'] = page_number;
        data['leaf_id'] = leaf_obj.leafId;
        final response = await dio.post(url + apiEndpoint, data: data);
        List<dynamic> result = response.data['data'];
        Map<String, dynamic> comment_set = {};
        List<Map<String, dynamic>> comments = [];
        Map<String, dynamic> comment_users = {};


        for(int i= 0; i< result.length; i++){
          var obj = LeafComments.fromJson(result[i]);
          comments.add(obj.toJson());
          comment_set[obj.commentId!]  = obj;
          print('-------');
          print(obj.comment);
          print(obj.commentDepth);
          print('-------');
          var user_obj_ = await userEngineObj.fetchUserInfoId(obj.commentedById!);
          comment_users[obj.commentId!] = user_obj_;
        }
        final commentTree = constructCommentTree(comments);
        final tree = convertTreeToMap(commentTree);

        CommentsRepo commentsRepo = CommentsRepo();
        commentsRepo.commentsTree = tree;
        commentsRepo.commentsMap = comment_set;
        commentsRepo.commentUsers = comment_users;
        commentsRepo.sortRootComments();
        return commentsRepo;
      } catch(e) {
        return CommentsRepo();
      }
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


  Future<dynamic> sendSubComment(dynamic data ) async {
    try {
      var apiEndpoint = 'leaf_engine/add_sub_comment';
      data['auth_token'] = sessionData!['auth_token'];
      data['token']  = sessionData!['token'];
      final response = await dio.post(url + apiEndpoint, data: data);
      print(response.data);
      if(response.data == -100){
        return true;
      } else{
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  Future<bool> deleteLeaf(String leaf_id) async {
    try {
      var apiEndpoint = 'leaf_engine/delete_leaf';
      var data = {};
      data['leaf_id'] = leaf_id;
      data['auth_token'] = sessionData!['auth_token'];
      data['token']  = sessionData!['token'];
      final response = await dio.post(url + apiEndpoint, data: data);
      final result = json.decode(response.data);
      if(result['message'] == -100){
        return true;
      } else{
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteLeafComment(String comment_id) async {
    try {
      var apiEndpoint = 'leaf_engine/delete_comment_by_id';
      var data = {};
      data['comment_id'] = comment_id;
      final response = await dio.post(url + apiEndpoint, data: data);
      final result = json.decode(response.data);
      if(result['message'] == -100){
        return true;
      } else{
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> getVote(String comment_id) async{
    try {
      var apiEndpoint = 'leaf_engine/get_vote';
      var box = await Hive.openBox('logged-in-user');
      var user_obj = box.get('user_obj');
      var data = {};
      data['comment_id'] = comment_id;
      data['user_id'] = user_obj.userId;
      final response = await dio.post(url + apiEndpoint, data: data);
      print(response.data);
      final result = json.decode(response.data);
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<bool> voteComment(String comment_id, String vote_action) async{
    try {
      var apiEndpoint = 'leaf_engine/vote_comment';
      var data = {};
      data['comment_id'] = comment_id;
      data['vote_action'] = vote_action;
      data['auth_token'] = sessionData!['auth_token'];
      data['token']  = sessionData!['token'];
      final response = await dio.post(url + apiEndpoint, data: data);

      final result = json.decode(response.data);
      print(result);
      if(result == 100){
        return true;
      } else{
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeVoteComment(String comment_id) async{
    try {
      var apiEndpoint = 'leaf_engine/remove_vote_comment';
      var data = {};
      data['comment_id'] = comment_id;
      data['auth_token'] = sessionData!['auth_token'];
      data['token']  = sessionData!['token'];
      final response = await dio.post(url + apiEndpoint, data: data);
      final result = json.decode(response.data);
      if(result == 100){
        return true;
      } else{
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}


