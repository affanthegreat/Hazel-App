

import 'CommentModels.dart';

class CommentsRepo{
  late Map<String, Map<dynamic, dynamic>> commentsTree;
  late Map<String, dynamic> commentsMap;


  LeafComments getCommentObj(String comment_id){
    return commentsMap[comment_id];
  }

}