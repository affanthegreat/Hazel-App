import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hazel_client/logics/LeafModel.dart';
import 'package:hazel_client/logics/leaf_engine.dart';
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
  }

  FutureOr<void> likeLeaf(LeafLikeEvent event, Emitter<LeafState> emit) async{
    emit(LeafLoadingState());
    try{
      await LeafEngine().likeLeaf(event.obj!);
    } catch(e){
      throw(e);
    }
    emit(LeafSuccessfulLoadState());
  }

  FutureOr<void> dislikeLeaf(LeafDislikeEvent event, Emitter<LeafState> emit) async {
    emit(LeafLoadingState());
    try{
      await LeafEngine().dislikeLeaf(event.obj!);
    } catch(e){
      throw(e);
    }
    emit(LeafSuccessfulLoadState());
  }

  FutureOr<void> removeLike(LeafLikeRemoveEvent event, Emitter<LeafState> emit) async {
    emit(LeafLoadingState());
    try{
      await LeafEngine().removeLikeLeaf(event.obj!);
    } catch(e){
      throw(e);
    }
    emit(LeafSuccessfulLoadState());
  }

  FutureOr<void> removeDislike(LeafDislikeRemoveEvent event, Emitter<LeafState> emit) async{
    emit(LeafLoadingState());
    try{
      await LeafEngine().removeDisLikeLeaf(event.obj!);
    } catch(e){
      throw(e);
    }
    emit(LeafSuccessfulLoadState());
  }

  FutureOr<void> loadLeaf(LeafLoadedEvent event, Emitter<LeafState> emit) async{
    emit(LeafLoadingState());
    try{
      await LeafEngine().addView(event.obj!);
    } catch(e){
      throw(e);
    }
    emit(LeafSuccessfulLoadState());
  }
}
