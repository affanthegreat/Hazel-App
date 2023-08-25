part of 'leaf_bloc.dart';

@immutable
abstract class LeafState {}

class LeafInitial extends LeafState {}

class LeafLoadingState extends LeafState{}

class LeafSuccessfulLoadState extends LeafState{
  final Map<String, bool> map;

  LeafSuccessfulLoadState(this.map);
}


class LeafFullScreenState extends LeafState{
  final Map<String, dynamic> map;
  final LeafModel? leaf;
  final UserProfileModel currentUser;
  final CommentsRepo commentData;

  LeafFullScreenState(this.map, this.leaf, this.currentUser, this.commentData);
}

class LeafErrorState extends LeafState{}

class LeafSendingComment extends LeafState{}

