part of 'user_profile_bloc.dart';

@immutable
abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileSuccessfulLoading extends UserProfileState{
  final UserProfileModel? obj;
  final Set<LeafModel?> privateLeafSet;
  final Set<LeafModel?> publicLeafSet;
  UserProfileSuccessfulLoading(this.obj, this.publicLeafSet, this.privateLeafSet);
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

  UserProfileVisit(this.obj, this.follow_map);
}

class UserProfileVisitError extends UserProfileState{
}

class UserProfileGetFollowersSuccesful extends UserProfileState{
  final Set<UserProfileModel?> listOfUsers;

  UserProfileGetFollowersSuccesful(this.listOfUsers);
}

class UserProfileGetFollowersError extends UserProfileState{}


class UserProfileGetFollowingSuccesful extends UserProfileState{
  final Set<UserProfileModel?> listOfUsers;

  UserProfileGetFollowingSuccesful(this.listOfUsers);
}

class UserProfileGetFollowingError extends UserProfileState{}

class UserProfileShowAllFollowRequests extends UserProfileState{
  final Set<UserProfileModel?> listOfUsers;
  UserProfileShowAllFollowRequests(this.listOfUsers);
}

class UserProfileFollowRequestsError extends UserProfileState{}

