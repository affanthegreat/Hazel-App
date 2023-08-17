import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hazel_client/logics/UserProfileModel.dart';
import 'package:hazel_client/logics/user_engine.dart';
import 'package:meta/meta.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc() : super(UserProfileInitial()) {



    on<UserProfileOnBeginEvent>(userProfileSync);
  }

  FutureOr<void> userProfileSync(UserProfileOnBeginEvent event, Emitter<UserProfileState> emit) async{
    UserProfileModel? userObj  = await UserEngine().fetchUserInfo();
    if(userObj == null){
      emit(UserProfileErrorLoading());
    }
    emit(UserProfileSuccessfulLoading(userObj));
  }
}
