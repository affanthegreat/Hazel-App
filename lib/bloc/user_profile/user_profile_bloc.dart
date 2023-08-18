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
    emit(UserProfileLoading());
    UserProfileModel? userObj  = await UserEngine().fetchUserInfo(event.refresh);
    print(userObj!.userExperiencePoints);
    if(userObj == null || userObj.userEmail == null){
      emit(UserProfileErrorLoading());
    }else{
      emit(UserProfileSuccessfulLoading(userObj));
    }

  }
}
