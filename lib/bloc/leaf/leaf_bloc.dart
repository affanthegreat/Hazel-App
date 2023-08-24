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


  LeafBloc() : super(LeafInitial()) {
    on<LeafLoadedEvent>(loadLeaf);
    on<LeafLikeEvent>(likeLeaf);
    on<LeafLikeRemoveEvent>(removeLike);
    on<LeafDislikeEvent>(dislikeLeaf);
    on<LeafDislikeRemoveEvent>(removeDislike);
    on<LeafFullScreenViewEvent>(fullScreenView);
    on<LeafSendComment>(sendComment);
  }

  FutureOr<void> likeLeaf(LeafLikeEvent event, Emitter<LeafState> emit) async{
    try{
      var status= await leafEngineObj.likeLeaf(event.obj!);
      if(status){
        event.obj!.likesCount = event.obj!.likesCount! + 1;
        bool dislike_status=  await leafEngineObj.checkDisLike(event!.obj!);
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
    try{
      var status = await leafEngineObj.dislikeLeaf(event.obj!);
      if(status){
        event.obj!.dislikesCount = event.obj!.dislikesCount! + 1;
        bool like_status=  await leafEngineObj.checkLike(event!.obj!);
        var interaction = {
          'like': like_status,
          'dislike': true
        };
        emit(LeafSuccessfulLoadState(interaction));
      }
    } catch(e){
      emit(LeafErrorState());
    }

  }

  FutureOr<void> removeLike(LeafLikeRemoveEvent event, Emitter<LeafState> emit) async {
    try{
      var status = await leafEngineObj.removeLikeLeaf(event.obj!);
      if(status){
        event.obj!.likesCount = event.obj!.likesCount! - 1;
        bool dislike_status=  await leafEngineObj.checkDisLike(event!.obj!);
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
      if(status){
        event.obj!.dislikesCount = event.obj!.dislikesCount! - 1;
        bool like_status= await leafEngineObj.checkLike(event!.obj!);
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
      bool like_status=  await leafEngineObj.checkLike(event!.obj!);
      bool dislike_status=  await leafEngineObj.checkDisLike(event!.obj!);
      var interaction = {
        'like': like_status,
        'dislike': dislike_status
      };
      emit(LeafSuccessfulLoadState(interaction));
    } catch(e){
      emit(LeafErrorState());
    }

  }

  FutureOr<void> fullScreenView(LeafFullScreenViewEvent event, Emitter<LeafState> emit) async{
    emit(LeafLoadingState());
    try{
      var comment_data = await leafEngineObj.getAllComments(event.obj!, commentsPage);
      emit(LeafFullScreenState(event.map, event.obj, event.currentUser, comment_data));
    }
    catch(e){
      emit(LeafErrorState());
    }
  }

  FutureOr<void> sendComment(LeafSendComment event, Emitter<LeafState> emit) async {
    emit(LeafSendingComment());
    try{
      await leafEngineObj.sendComment(event.commentString, event.obj!);
      var comment_data = await leafEngineObj.getAllComments(event.obj!, commentsPage);
      emit(LeafFullScreenState(event.map, event.obj, event.currentUser, comment_data));
    } catch(e){
      emit(LeafErrorState());
    }

  }
}
