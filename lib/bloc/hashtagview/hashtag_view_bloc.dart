import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'hashtag_view_event.dart';
part 'hashtag_view_state.dart';

class HashtagViewBloc extends Bloc<HashtagViewEvent, HashtagViewState> {
  HashtagViewBloc() : super(HashtagViewInitial()) {
      on<HashtagLoadLeaves>(loadLeaves);
  }

  FutureOr<void> loadLeaves(HashtagLoadLeaves event, Emitter<HashtagViewState> emit) async{
  }
}
