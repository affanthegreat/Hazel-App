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

  UserProfileVisit(this.obj);
}