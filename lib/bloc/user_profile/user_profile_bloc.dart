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
    on<UserProfileSearchEvent>(userProfileSearch);
    on<UserProfileVisitEvent>(userProfileVisit);
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

  FutureOr<void> userProfileSearch(UserProfileSearchEvent event, Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try{
        var user_list = await UserEngine().searchUserInfo({'search_query': event.search_query, 'page_number':event.page_number});
        emit(UserProfileSearchSuccessful(user_list));

    } catch(e){
      emit(UserProfileSearchFailure());
    }
  }

  FutureOr<void> userProfileVisit(UserProfileVisitEvent event, Emitter<UserProfileState> emit) {
    emit(UserProfileVisit(event.profile));
  }
}
