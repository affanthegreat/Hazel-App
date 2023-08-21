class LeafModel {
  String? createdDate;
  String? ownerId;
  String? textContent;
  String? leafId;
  String? imageContent;
  int? likesCount;
  int? dislikesCount;
  int? commentsCount;
  int? viewCount;
  String? leafType;
  String? engagementRating;
  String? experienceRating;
  String? expPoints;
  String? previousAnalyticsRun;
  int? leafTopicId;
  int? leafTopicCategoryId;
  String? leafSentiment;
  String? leafEmotionState;
  bool? isPromoted;
  bool? isAdvertisement;
  String? topicRelevenacyPercentage;
  String? categoryRelevancyPercentage;

  LeafModel(
      {this.createdDate,
        this.ownerId,
        this.textContent,
        this.leafId,
        this.imageContent,
        this.likesCount,
        this.dislikesCount,
        this.commentsCount,
        this.viewCount,
        this.leafType,
        this.engagementRating,
        this.experienceRating,
        this.expPoints,
        this.previousAnalyticsRun,
        this.leafTopicId,
        this.leafTopicCategoryId,
        this.leafSentiment,
        this.leafEmotionState,
        this.isPromoted,
        this.isAdvertisement,
        this.topicRelevenacyPercentage,
        this.categoryRelevancyPercentage});

  LeafModel.fromJson(Map<String, dynamic> json) {
    createdDate = json['created_date'];
    ownerId = json['owner_id'];
    textContent = json['text_content'];
    leafId = json['leaf_id'];
    imageContent = json['image_content'];
    likesCount = json['likes_count'];
    dislikesCount = json['dislikes_count'];
    commentsCount = json['comments_count'];
    viewCount = json['view_count'];
    leafType = json['leaf_type'];
    engagementRating = json['engagement_rating'];
    experienceRating = json['experience_rating'];
    expPoints = json['exp_points'];
    previousAnalyticsRun = json['previous_analytics_run'];
    leafTopicId = json['leaf_topic_id'];
    leafTopicCategoryId = json['leaf_topic_category_id'];
    leafSentiment = json['leaf_sentiment'];
    leafEmotionState = json['leaf_emotion_state'];
    isPromoted = json['is_promoted'];
    isAdvertisement = json['is_advertisement'];
    topicRelevenacyPercentage = json['topic_relevenacy_percentage'];
    categoryRelevancyPercentage = json['category_relevancy_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_date'] = this.createdDate;
    data['owner_id'] = this.ownerId;
    data['text_content'] = this.textContent;
    data['leaf_id'] = this.leafId;
    data['image_content'] = this.imageContent;
    data['likes_count'] = this.likesCount;
    data['dislikes_count'] = this.dislikesCount;
    data['comments_count'] = this.commentsCount;
    data['view_count'] = this.viewCount;
    data['leaf_type'] = this.leafType;
    data['engagement_rating'] = this.engagementRating;
    data['experience_rating'] = this.experienceRating;
    data['exp_points'] = this.expPoints;
    data['previous_analytics_run'] = this.previousAnalyticsRun;
    data['leaf_topic_id'] = this.leafTopicId;
    data['leaf_topic_category_id'] = this.leafTopicCategoryId;
    data['leaf_sentiment'] = this.leafSentiment;
    data['leaf_emotion_state'] = this.leafEmotionState;
    data['is_promoted'] = this.isPromoted;
    data['is_advertisement'] = this.isAdvertisement;
    data['topic_relevenacy_percentage'] = this.topicRelevenacyPercentage;
    data['category_relevancy_percentage'] = this.categoryRelevancyPercentage;
    return data;
  }
}