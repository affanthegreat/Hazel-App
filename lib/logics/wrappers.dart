

import 'CommentModels.dart';

class CommentsRepo{
  late Map<String, Map<dynamic, dynamic>> commentsTree;
  late Map<String, dynamic> commentsMap;


  LeafComments getCommentObj(String comment_id){
    return commentsMap[comment_id];
  }
  sortRootComments(){
    List<String> root_comments_list = commentsTree.keys.toList();
    root_comments_list.sort((a,b) =>   DateTime.parse(commentsMap[a]!.createdDate).compareTo(DateTime.parse(commentsMap[b]!.createdDate)));
    var reversedList = List.from(root_comments_list.reversed);
    Map<String, Map<dynamic, dynamic>> new_map = {};
    for(var i in reversedList){
      new_map[i] = commentsTree[i]!;
    }
    commentsTree = new_map;
  }
}