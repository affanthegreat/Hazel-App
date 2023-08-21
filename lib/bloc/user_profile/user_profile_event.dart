part of 'user_profile_bloc.dart';

@immutable
abstract class UserProfileEvent {}

class UserProfileOnBeginEvent extends UserProfileEvent{
  final bool refresh;

  UserProfileOnBeginEvent(this.refresh);

}

class UserProfileSearchEvent extends UserProfileEvent{
  final String search_query;
  final int page_number;
  UserProfileSearchEvent(this.search_query,this.page_number);
}

class UserProfileVisitEvent extends UserProfileEvent{
  final UserProfileModel? profile;

  UserProfileVisitEvent(this.profile);

}

class UserProfileSeeFollowersEvent extends UserProfileEvent{}

class UserProfileSeeFollowingEvent extends UserProfileEvent{}

class UserProfileSendFollowRequestEvent extends UserProfileEvent{
  final UserProfileModel? obj;
  final dynamic follow_map;

  UserProfileSendFollowRequestEvent(this.obj, this.follow_map);

}

class UserProfileRemoveFollowRequestEvent extends UserProfileEvent{
  final UserProfileModel? obj;
  final dynamic follow_map;

  UserProfileRemoveFollowRequestEvent(this.obj, this.follow_map);

}


class UserProfileViewFollowRequestsEvent extends UserProfileEvent{}


class UserAcceptFollowRequest extends UserProfileEvent{
  final UserProfileModel? obj;
  UserAcceptFollowRequest(this.obj);

}


class UserRemoveFollowRequest extends UserProfileEvent{
  final UserProfileModel? obj;
  UserRemoveFollowRequest(this.obj);
}

class UserProfileRemoveFollower extends UserProfileEvent{
  final String? followerUserId;
  final String? followingUserId;
  final UserProfileModel? obj;

  UserProfileRemoveFollower(this.followerUserId, this.followingUserId, this.obj);
}

class UserProfileBlockUserEvent extends UserProfileEvent{
  final UserProfileModel? obj;

  UserProfileBlockUserEvent(this.obj);
}

class UserProfileUnBlockUserEvent extends UserProfileEvent{
  final UserProfileModel? obj;

  UserProfileUnBlockUserEvent(this.obj);
}

