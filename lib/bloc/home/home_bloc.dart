import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hazel_client/logics/leaf_engine.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeSuccessfullyLoadedEvent>(homeSuccessEvent);
    on<HomeCreateLeafEvent>(homeCreateLeafEvent);
  }

  FutureOr<void> homeCreateLeafEvent(HomeCreateLeafEvent event, Emitter<HomeState> emit) async {

    emit(HomeLeafCreationLoading());
    try{
      var response = await LeafEngine().createLeaf({
        'leaf_type': event.leaf_type,
        'text_content': event.text_content
      });
      if(response){
        emit(HomeLeafCreationSuccessfulState());
      } else {
        emit(HomeLeafCreationFailureState());
      }
    } catch(e){
      emit(HomeLeafCreationFailureState());
    }
  }

  FutureOr<void> homeSuccessEvent(HomeSuccessfullyLoadedEvent event, Emitter<HomeState> emit) {
    emit(HomeSuccessfullyLoaded());
  }
}
