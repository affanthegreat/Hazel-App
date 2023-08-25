import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hazel_client/logics/LeafModel.dart';
import 'package:hazel_client/logics/UserProfileModel.dart';
import 'package:hazel_client/logics/wrappers.dart';
import 'package:hazel_client/main.dart';
import 'package:meta/meta.dart';

part 'leaf_event.dart';
part 'leaf_state.dart';

class LeafBloc extends Bloc<LeafEvent, LeafState> {

  int commentsPage = 1;
  CommentsRepo? commentData;

  LeafBloc() : super(LeafInitial()) {
    on<LeafLoadedEvent>(loadLeaf);
    on<LeafLikeEvent>(likeLeaf);
   // on<LeafFullScreenLikeEvent>(likeFullScreen);
    on<LeafLikeRemoveEvent>(removeLike);
   // on<LeafFullScreenLikeRemoveEvent>(removeLikeFullScreen);

    on<LeafDislikeEvent>(dislikeLeaf);
   // on<LeafFullScreenDislikeEvent>(dislikeFullScreen);
    on<LeafDislikeRemoveEvent>(removeDislike);
   // on<LeafFullScreenRemoveDislikeEvent>(removeDislikeFullScreen);
    on<LeafFullScreenViewEvent>(fullScreenView);
    on<LeafSendComment>(sendComment);
    on<LeafDelete>(deleteLeaf);
    on<LeafDeleteComments>(deleteLeafComment);
    on<LeafSubComment>(sendSubComment);
  }

  FutureOr<void> likeLeaf(LeafLikeEvent event, Emitter<LeafState> emit) async{
    try{
      var status= await leafEngineObj.likeLeaf(event.obj!);
      if(status == -100){
        event.obj!.likesCount = event.obj!.likesCount! + 1;
        bool dislike_status=  await leafEngineObj.checkDisLike(event.obj!);
        var interaction = {
          'like': true,
          'dislike': dislike_status
        };
        emit(LeafSuccessfulLoadState(interaction));
      }
    } catch(e){
      emit(LeafErrorState());
    }
  }



  FutureOr<void> dislikeLeaf(LeafDislikeEvent event, Emitter<LeafState> emit) async {

      var status = await leafEngineObj.dislikeLeaf(event.obj!);
      if(status == -100){
        event.obj!.dislikesCount = event.obj!.dislikesCount! + 1;
        bool like_status=  await leafEngineObj.checkLike(event.obj!);
        var interaction = {
          'like': like_status,
          'dislike': true
        };
        emit(LeafSuccessfulLoadState(interaction));
      }


  }

  FutureOr<void> removeLike(LeafLikeRemoveEvent event, Emitter<LeafState> emit) async {
    try{
      var status = await leafEngineObj.removeLikeLeaf(event.obj!);
      if(status == -100){
        event.obj!.likesCount = event.obj!.likesCount! - 1;
        bool dislike_status=  await leafEngineObj.checkDisLike(event.obj!);
        var interaction = {
          'like': false,
          'dislike': dislike_status
        };
        emit(LeafSuccessfulLoadState(interaction));
      }
    } catch(e){
      emit(LeafErrorState());
    }

  }

  FutureOr<void> removeDislike(LeafDislikeRemoveEvent event, Emitter<LeafState> emit) async{
    try{
      var status = await leafEngineObj.removeDisLikeLeaf(event.obj!);
      if(status == -100){
        event.obj!.dislikesCount = event.obj!.dislikesCount! - 1;
        bool like_status=  await leafEngineObj.checkLike(event.obj!);
        var interaction = {
          'like': like_status,
          'dislike': false
        };
        emit(LeafSuccessfulLoadState(interaction));
      }
    } catch(e){
      emit(LeafErrorState());
    }

  }

  FutureOr<void> loadLeaf(LeafLoadedEvent event, Emitter<LeafState> emit) async{
    emit(LeafLoadingState());
    try{
      await leafEngineObj.addView(event.obj!);
      bool dislike_status=  await leafEngineObj.checkDisLike(event.obj!);
      bool like_status=  await leafEngineObj.checkLike(event.obj!);
      var interaction = {
        'like': like_status,
        'dislike': dislike_status
      };
      emit(LeafSuccessfulLoadState(interaction));
    } catch(e){
      emit(LeafErrorState());
    }

  }
  var map;
  var obj;
  var currentUser;
  var commentDataF;
  FutureOr<void> fullScreenView(LeafFullScreenViewEvent event, Emitter<LeafState> emit) async {
    if(commentData == null){
      emit(LeafLoadingState());
    }
    try {
      var comment_data = await leafEngineObj.getAllComments(event.obj!, commentsPage);

      if (commentData == null || comment_data.commentsTree != commentData!.commentsTree) {
        if (commentsPage == 1) {
          print("Saving into comment data");
          commentData = comment_data;
        } else {
          print("Merging data");
          commentData!.merge(comment_data);
        }
      }
      map = event.map;
      obj = event.obj;
      currentUser = event.currentUser;
      commentDataF = commentData!;
      emit(LeafFullScreenState(event.map, event.obj, event.currentUser, commentData!));
    } catch (e) {
      // Handle error
      emit(LeafErrorState());
    }
  }


  FutureOr<void> sendComment(LeafSendComment event, Emitter<LeafState> emit) async {
    emit(LeafSendingComment());
    try{
      await leafEngineObj.sendComment(event.commentString, event.obj!);
      var comment_data = await leafEngineObj.getAllComments(event.obj!, 1);
      emit(LeafFullScreenState(event.map, event.obj, event.currentUser, comment_data));
    } catch(e){
      emit(LeafErrorState());
    }
  }

  FutureOr<void> deleteLeaf(LeafDelete event, Emitter<LeafState> emit)  async{
    emit(LeafLoadingState());
    try{
      var delete_status = await leafEngineObj.deleteLeaf(event.leaf_id);
      print(delete_status);
      if(delete_status){
        emit(LeafSuccessfulDelete());
      } else{
        emit(LeafDeleteError());
      }

    } catch(E){
      emit(LeafErrorState());
    }
  }

  FutureOr<void> sendSubComment(LeafSubComment event, Emitter<LeafState> emit) async {
    print("here");
    emit(LeafSendingComment());
    try{
      await leafEngineObj.sendSubComment(event.data);
      var comment_data = await leafEngineObj.getAllComments(obj!, 1);
      emit(LeafFullScreenState(map, obj, currentUser, comment_data));
    } catch(e){
      emit(LeafErrorState());
    }
  }



  FutureOr<void> deleteLeafComment(LeafDeleteComments event, Emitter<LeafState> emit) async{
    emit(LeafCommentDeleting());
    try{
      await leafEngineObj.deleteLeafComment(event.commentId);
      var comment_data = await leafEngineObj.getAllComments(obj!, 1);
      emit(LeafSuccessfulDeleteComment());
      emit(LeafFullScreenState(map, obj, currentUser, comment_data));

    } catch(e){
      emit(LeafCommentDeleteError());
    }
  }
}
