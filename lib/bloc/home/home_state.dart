part of 'home_bloc.dart';

@immutable
abstract class HomeState {}


class HomeSuccessfullyLoaded extends HomeState{}

class HomeInitial extends HomeState {}

class HomeLeafCreationSuccessfulState extends HomeState{}

class HomeLeafCreationFailureState extends HomeState{}

class HomeLeafCreationLoading extends HomeState{}

