part of 'user_profile_bloc.dart';

@immutable
abstract class UserProfileEvent {}

class UserProfileOnBeginEvent extends UserProfileEvent{
  final bool refresh;

  UserProfileOnBeginEvent(this.refresh);

}

