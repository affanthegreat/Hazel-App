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

      var validMentions = await LeafEngine().checkValidMentions(event.text_content);
      if(validMentions){
        var response = await LeafEngine().createLeaf({
          'leaf_type': event.leaf_type,
          'text_content': event.text_content
        });
        if(response){
          emit(HomeLeafCreationSuccessfulState());
        } else {
          emit(HomeLeafCreationFailureState());
        }
      } else{
        emit(HomeLeafInvalidMentions());
      }


  }

  FutureOr<void> homeSuccessEvent(HomeSuccessfullyLoadedEvent event, Emitter<HomeState> emit) {
    emit(HomeSuccessfullyLoaded());
  }
}
