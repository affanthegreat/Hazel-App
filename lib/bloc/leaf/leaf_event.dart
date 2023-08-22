part of 'leaf_bloc.dart';

@immutable
abstract class LeafEvent {}

class LeafLoadedEvent extends LeafEvent{
  final LeafModel? obj;
  final UserProfileModel? user_obj;
  LeafLoadedEvent(this.obj, this.user_obj);
}

class LeafLikeEvent extends LeafEvent{
  final LeafModel? obj;

  LeafLikeEvent(this.obj);
}

class LeafLikeRemoveEvent extends LeafEvent{
  final LeafModel? obj;

  LeafLikeRemoveEvent(this.obj);
}

class LeafDislikeEvent extends LeafEvent{
  final LeafModel? obj;

  LeafDislikeEvent(this.obj);
}

class LeafDislikeRemoveEvent extends LeafEvent{
  final LeafModel? obj;

  LeafDislikeRemoveEvent(this.obj);
}
