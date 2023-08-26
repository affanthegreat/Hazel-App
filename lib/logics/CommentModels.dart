class LeafComments {
  String? commentId;
  String? leafId;
  String? commentedById;
  String? comment;
  int? commentDepth;
  String? commentSentiment;
  String? commentEmotion;
  String? rootCommentId;
  String? parentCommentId;
  String? createdDate;
  int? votes;

  LeafComments(
      {this.commentId,
        this.leafId,
        this.commentedById,
        this.comment,
        this.commentDepth,
        this.commentSentiment,
        this.commentEmotion,
        this.rootCommentId,
        this.parentCommentId,
        this.createdDate,
        this.votes,
      });

  LeafComments.fromJson(Map<String, dynamic> json) {
    commentId = json['comment_id'];
    leafId = json['leaf_id'];
    commentedById = json['commented_by_id'];
    comment = json['comment'];
    commentDepth = json['comment_depth'];
    commentSentiment = json['comment_sentiment'];
    commentEmotion = json['comment_emotion'];
    rootCommentId = json['root_comment_id'];
    parentCommentId = json['parent_comment_id'];
    createdDate = json['created_date'];
    votes = json['votes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment_id'] = this.commentId;
    data['leaf_id'] = this.leafId;
    data['commented_by_id'] = this.commentedById;
    data['comment'] = this.comment;
    data['comment_depth'] = this.commentDepth;
    data['comment_sentiment'] = this.commentSentiment;
    data['comment_emotion'] = this.commentEmotion;
    data['root_comment_id'] = this.rootCommentId;
    data['parent_comment_id'] = this.parentCommentId;
    data['created_date'] = this.createdDate;
    data['votes'] = this.votes;
    return data;
  }
}
