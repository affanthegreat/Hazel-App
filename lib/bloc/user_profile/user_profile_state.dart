part of 'user_profile_bloc.dart';

@immutable
abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileSuccessfulLoading extends UserProfileState{
  final UserProfileModel? obj;
  final Set<LeafModel?> privateLeafSet;
  final Set<LeafModel?> publicLeafSet;

  UserProfileSuccessfulLoading(this.obj,this.publicLeafSet, this.privateLeafSet);
}

class UserProfileErrorLoading extends UserProfileState{}

class UserProfileLoading extends UserProfileState{}

class UserProfileSearchSuccessful extends UserProfileState{
  final Set<UserProfileModel?> listOfUsers;

  UserProfileSearchSuccessful(this.listOfUsers);
}

class UserProfileSearchFailure extends UserProfileState{}

class UserProfileVisit extends UserProfileState{
  final UserProfileModel? obj;
  final dynamic follow_map;
  final Set<LeafModel?> leaves;
  UserProfileVisit(this.obj, this.follow_map, this.leaves);
}

class UserProfileVisitError extends UserProfileState{
}

class UserProfileGetFollowersSuccesful extends UserProfileState{
  final Set<UserProfileModel?> listOfUsers;
  final String userId;

  UserProfileGetFollowersSuccesful(this.listOfUsers, this.userId);
}

class UserProfileGetFollowersError extends UserProfileState{}


class UserProfileGetFollowingSuccesful extends UserProfileState{
  final Set<UserProfileModel?> listOfUsers;
  final String userId;

  UserProfileGetFollowingSuccesful(this.listOfUsers, this.userId);
}

class UserProfileGetFollowingError extends UserProfileState{}

class UserProfileShowAllFollowRequests extends UserProfileState{
  final Set<UserProfileModel?> listOfUsers;
  UserProfileShowAllFollowRequests(this.listOfUsers);
}

class UserProfileFollowRequestsError extends UserProfileState{}

