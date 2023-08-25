part of 'hashtag_view_bloc.dart';

@immutable
abstract class HashtagViewState {}

class HashtagViewInitial extends HashtagViewState {}


class HashTagViewLoading extends HashtagViewState{}

class HashTagViewSuccessfullyLoaded extends HashtagViewState{}

class HashTagViewError extends HashtagViewState{}