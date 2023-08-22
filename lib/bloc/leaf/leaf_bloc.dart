import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hazel_client/logics/LeafModel.dart';
import 'package:hazel_client/logics/UserProfileModel.dart';
import 'package:hazel_client/logics/leaf_engine.dart';
import 'package:hazel_client/main.dart';
import 'package:meta/meta.dart';

part 'leaf_event.dart';
part 'leaf_state.dart';

class LeafBloc extends Bloc<LeafEvent, LeafState> {
  LeafBloc() : super(LeafInitial()) {
    on<LeafLoadedEvent>(loadLeaf);
    on<LeafLikeEvent>(likeLeaf);
    on<LeafLikeRemoveEvent>(removeLike);
    on<LeafDislikeEvent>(dislikeLeaf);
    on<LeafDislikeRemoveEvent>(removeDislike);
    on<LeafFullScreenViewEvent>(fullScreenView);
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
      throw(e);
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
      throw(e);
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
      throw(e);
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
      throw(e);
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
      throw(e);
    }

  }

  FutureOr<void> fullScreenView(LeafFullScreenViewEvent event, Emitter<LeafState> emit) {
    emit(LeafLoadingState());
    emit(LeafFullScreenState(event.map, event.obj, event.currentUser));
  }
}
