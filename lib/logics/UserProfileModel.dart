import 'package:hive/hive.dart';


part 'UserProfileModel.g.dart';

@HiveType(typeId: 1)
class UserProfileModel {
  @HiveField(0)
  String? userEmail;
  @HiveField(1)
  String? userName;
  @HiveField(2)
  int? userPublicLeafCount;
  @HiveField(3)
  int? userPrivateLeafCount;
  @HiveField(4)
  int? userExperiencePoints;
  @HiveField(5)
  bool? userVerified;
  @HiveField(6)
  int? userFollowers;
  @HiveField(7)
  int? userFollowing;
  @HiveField(8)
  int? userLevel;
  @HiveField(9)
  int? userUniversalLikes;
  @HiveField(10)
  int? userUniversalDislikes;
  @HiveField(11)
  int? userUniversalComments;
  @HiveField(12)
  String? createdAt;
  @HiveField(13)
  String? userId;

  UserProfileModel(
      {this.userEmail,
        this.userName,
        this.userPublicLeafCount,
        this.userPrivateLeafCount,
        this.userExperiencePoints,
        this.userVerified,
        this.userFollowers,
        this.userFollowing,
        this.userLevel,
        this.userUniversalLikes,
        this.userUniversalDislikes,
        this.userUniversalComments,
        this.createdAt,
        this.userId
      });

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    userEmail = json['user_email'];
    userName = json['user_name'];
    userPublicLeafCount = json['user_public_leaf_count'];
    userPrivateLeafCount = json['user_private_leaf_count'];
    userExperiencePoints = json['user_experience_points'];
    userVerified = json['user_verified'];
    userFollowers = json['user_followers'];
    userFollowing = json['user_following'];
    userLevel = json['user_level'];
    userUniversalLikes = json['user_universal_likes'];
    userUniversalDislikes = json['user_universal_dislikes'];
    userUniversalComments = json['user_universal_comments'];
    createdAt = json['created_at'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_email'] = this.userEmail;
    data['user_name'] = this.userName;
    data['user_public_leaf_count'] = this.userPublicLeafCount;
    data['user_private_leaf_count'] = this.userPrivateLeafCount;
    data['user_experience_points'] = this.userExperiencePoints;
    data['user_verified'] = this.userVerified;
    data['user_followers'] = this.userFollowers;
    data['user_following'] = this.userFollowing;
    data['user_level'] = this.userLevel;
    data['user_universal_likes'] = this.userUniversalLikes;
    data['user_universal_dislikes'] = this.userUniversalDislikes;
    data['user_universal_comments'] = this.userUniversalComments;
    data['created_at'] = this.createdAt;
    data['userId'] = this.userId;
    return data;
  }
  int getExperiencePointsForLevel(int level, {int basePoints = 750, int multiplier = 2}) {
    if (level == 0) {
      return 0;
    }
    int previousLevelPoints = getExperiencePointsForLevel(level - 1, basePoints: basePoints, multiplier: multiplier);
    return previousLevelPoints > 0 ? previousLevelPoints * multiplier : basePoints;
  }

  int experienceNeededForLevelUp(int currentExp, {int basePoints = 750, int multiplier = 2}) {
    int currentLevel = 1;
    int nextLevelPoints = getExperiencePointsForLevel(currentLevel + 1, basePoints: basePoints, multiplier: multiplier);
    return nextLevelPoints;
  }

  int generateLevel(int userExp, {int basePoints = 750, int multiplier = 2}) {
    if (userExp < getExperiencePointsForLevel(1, basePoints: basePoints, multiplier: multiplier)) {
      return 0;
    }
    int level = 1;
    while (userExp >= getExperiencePointsForLevel(level, basePoints: basePoints, multiplier: multiplier)) {
      userExp -= getExperiencePointsForLevel(level, basePoints: basePoints, multiplier: multiplier);
      level += 1;
    }
    return level - 1;
  }
}