part of 'user_profile_bloc.dart';

@immutable
abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileSuccessfulLoading extends UserProfileState{
  final UserProfileModel? obj;

  UserProfileSuccessfulLoading(this.obj);
}

class UserProfileErrorLoading extends UserProfileState{}