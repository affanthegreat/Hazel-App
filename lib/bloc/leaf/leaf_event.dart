part of 'leaf_bloc.dart';

@immutable
abstract class LeafEvent {}

class LeafLoadedEvent extends LeafEvent{
  final LeafModel? obj;
  final UserProfileModel? user_obj;
  LeafLoadedEvent(this.obj, this.user_obj);
}
//LIKE
class LeafLikeEvent extends LeafEvent{
  final LeafModel? obj;

  LeafLikeEvent(this.obj);
}

class LeafFullScreenLikeEvent extends LeafEvent{
  final LeafModel? obj;

  LeafFullScreenLikeEvent(this.obj);
}

//LIKE REMOVE
class LeafLikeRemoveEvent extends LeafEvent{
  final LeafModel? obj;

  LeafLikeRemoveEvent(this.obj);
}

class LeafFullScreenLikeRemoveEvent extends LeafEvent{
  final LeafModel? obj;

  LeafFullScreenLikeRemoveEvent(this.obj);
}

// DISLIKE
class LeafDislikeEvent extends LeafEvent{
  final LeafModel? obj;

  LeafDislikeEvent(this.obj);
}


class LeafFullScreenDislikeEvent extends LeafEvent{
  final LeafModel? obj;

  LeafFullScreenDislikeEvent(this.obj);
}

// DISLIKE REMOVE
class LeafDislikeRemoveEvent extends LeafEvent{
  final LeafModel? obj;

  LeafDislikeRemoveEvent(this.obj);
}


class LeafFullScreenRemoveDislikeEvent extends LeafEvent{
  final LeafModel? obj;

  LeafFullScreenRemoveDislikeEvent(this.obj);
}



class LeafFullScreenViewEvent extends LeafEvent{
  final LeafModel? obj;
  final UserProfileModel currentUser;
  final Map<String, dynamic> map;

  LeafFullScreenViewEvent(this.obj, this.currentUser, this.map);

}

class LeafSendComment extends LeafEvent{
  final String commentString;
  final LeafModel? obj;
  final UserProfileModel currentUser;
  final Map<String, dynamic> map;

  LeafSendComment(this.commentString, this.obj, this.currentUser, this.map);
}

class LeafSubComment extends LeafEvent{
  final Map data;
  LeafSubComment(this.data);
}


class LeafDelete extends LeafEvent{
  final String leaf_id;

  LeafDelete(this.leaf_id);
}

class LeafDeleteComments extends LeafEvent{
  final String commentId;

  LeafDeleteComments(this.commentId);
}