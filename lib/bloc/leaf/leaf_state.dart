part of 'leaf_bloc.dart';

@immutable
abstract class LeafState {}

class LeafInitial extends LeafState {}

class LeafLoadingState extends LeafState{

}

class LeafSuccessfulLoadState extends LeafState{
  final Map<String, bool> map;

  LeafSuccessfulLoadState(this.map);
}


class LeafFullScreenState extends LeafState{
  final Map<String, bool> map;
  final LeafModel? leaf;
  final UserProfileModel currentUser;

  LeafFullScreenState(this.map, this.leaf, this.currentUser);
}