part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeCreateLeafEvent extends HomeEvent{
  final String text_content;
  final String leaf_type;

  HomeCreateLeafEvent(this.text_content, this.leaf_type);
}


class HomeSuccessfullyLoadedEvent extends HomeEvent{}