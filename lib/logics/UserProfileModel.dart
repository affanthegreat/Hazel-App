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
  @HiveField(14)
  String? userFullName;
  @HiveField(15)
  String? userPhoneNumber;
  @HiveField(16)
  String? userAddress;
  @HiveField(17)
  String? userPhoneId;
  @HiveField(18)
  String? userCity;
  @HiveField(19)
  String? userState;
  @HiveField(20)
  String? userCountry;
  @HiveField(21)
  String? userRegion;
  @HiveField(22)
  String? userGender;
  @HiveField(23)
  int? userAge;
  @HiveField(24)
  String? userBio;

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
      this.userId,
      this.userFullName,
      this.userPhoneNumber,
      this.userAddress,
      this.userPhoneId,
      this.userCity,
      this.userState,
      this.userCountry,
      this.userRegion,
      this.userGender,
      this.userAge,
      this.userBio});

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
    userFullName = json['user_full_name'];
    userPhoneNumber = json['user_phone_number'];
    userAddress = json['user_address'];
    userPhoneId = json['user_phone_id'];
    userCity = json['user_city'];
    userState = json['user_state'];
    userCountry = json['user_country'];
    userRegion = json['user_region'];
    userGender = json['user_gender'];
    userAge = json['user_age'];
    userBio = json['user_bio'];
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
    data['user_full_name'] = this.userFullName;
    data['user_phone_number'] = this.userPhoneNumber;
    data['user_address'] = this.userAddress;
    data['user_phone_id'] = this.userPhoneId;
    data['user_city'] = this.userCity;
    data['user_state'] = this.userState;
    data['user_country'] = this.userCountry;
    data['user_region'] = this.userRegion;
    data['user_gender'] = this.userGender;
    data['user_age'] = this.userAge;
    data['user_bio'] = this.userBio;
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
