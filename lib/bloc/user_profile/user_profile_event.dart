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