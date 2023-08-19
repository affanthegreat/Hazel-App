part of 'user_profile_bloc.dart';

@immutable
abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileSuccessfulLoading extends UserProfileState{
  final UserProfileModel? obj;

  UserProfileSuccessfulLoading(this.obj);
}

class UserProfileErrorLoading extends UserProfileState{}

class UserProfileLoading extends UserProfileState{}

class UserProfileSearchSuccessful extends UserProfileState{
  final List<UserProfileModel?> listOfUsers;

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
  final List<UserProfileModel?> listOfUsers;

  UserProfileGetFollowersSuccesful(this.listOfUsers);
}

class UserProfileGetFollowersError extends UserProfileState{}


class UserProfileGetFollowingSuccesful extends UserProfileState{
  final List<UserProfileModel?> listOfUsers;

  UserProfileGetFollowingSuccesful(this.listOfUsers);
}

class UserProfileGetFollowingError extends UserProfileState{}

class UserProfileShowAllFollowRequests extends UserProfileState{
  final List<UserProfileModel?> listOfUsers;
  UserProfileShowAllFollowRequests(this.listOfUsers);
}

class UserProfileFollowRequestsError extends UserProfileState{}

