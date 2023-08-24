

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

  void merge(CommentsRepo otherRepo) {
    commentsTree.addAll(otherRepo.commentsTree);
    commentsMap.addAll(otherRepo.commentsMap);
    sortRootComments();
  }
}


class CommentNode {
  final Map<String, dynamic> comment;
  final List<CommentNode> children;

  CommentNode({required this.comment, this.children = const []});
}

List<CommentNode> constructCommentTree(List<Map<String, dynamic>> sortedComments) {
  Map<String, CommentNode> commentTree = {};

  for (var commentData in sortedComments) {
    final commentId = commentData['comment_id'];
    final parentCommentId = commentData['parent_comment_id'];

    final commentNode = CommentNode(comment: commentData, children: []);

    if (!commentTree.containsKey(commentId)) {
      commentTree[commentId] = commentNode;
    }

    if (parentCommentId != null) {
      if (commentTree.containsKey(parentCommentId)) {
        commentTree[parentCommentId]!.children.add(commentNode);
      }
    }
  }

  return commentTree.values.where((node) => node.comment['comment_depth'] == 1).toList();
}

class RelationshipStatus {
  final bool followRequestStatus;
  final bool followingStatus;
  final bool followerStatus;
  final bool blockStatus;
  final bool blockedByStatus;

  RelationshipStatus({
    required this.followRequestStatus,
    required this.followingStatus,
    required this.followerStatus,
    required this.blockStatus,
    required this.blockedByStatus,
  });
}
