import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hazel_client/logics/user_engine.dart';
import 'package:hazel_client/screens/sign_up/main_signup.dart';
import 'package:meta/meta.dart';



part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    FutureOr<void> signUpStartEvent(SignUpStartEvent event,
        Emitter<SignUpState> emit) {
      emit(SignUpStartSuccess(true));
    }

    FutureOr<void> signUpEmailAddedEvent(SignUpEmailAddedEvent event,
        Emitter<SignUpState> emit) async {
      final bool user_status =await UserEngine().checkUserExists({'user_email':event.email});
      if(user_status){
        emit(SignUpEmailAddedState());
      }else{
        emit(SignUpEmailErrorState());
      }
    }
    FutureOr<void> signUpUserNameEvent(SignUpUserNameEvent event,
        Emitter<SignUpState> emit) async {
      final bool user_status = await UserEngine().checkUserExists(
          {'user_name': event.userName});
      if (user_status) {
        emit(SignUpUserNameAddedState());
      } else {
        emit(SignUpUserNameErrorState());
      }
    }
    FutureOr<void> signUpPasswordCheck1Event(SignUpPasswordCheck1Event event, Emitter<SignUpState> emit) {
      if(UserEngine().validateStructure(event.password)){
        emit(SignUpUserPasswordState());
      } else{
        emit(SignUpPasswordErrorState());
      }
    }

    FutureOr<void> signUpDataCollectedEvent(SignUpDataCollectedEvent event, Emitter<SignUpState> emit) async{
      var data = {
        'user_email': event.email,
        'user_password': event.password,
        'user_name': event.userName
      };
      var creation_status = await UserEngine().createUser(data);
      if(creation_status){
        emit(SignupAccountCreationSuccessful());
      } else{
        emit(SignupAccountCreationError());
      }


    }

    on<SignUpStartEvent>(signUpStartEvent);
    on<SignUpEmailAddedEvent>(signUpEmailAddedEvent);
    on<SignUpUserNameEvent>(signUpUserNameEvent);
    on<SignUpPasswordCheck1Event>(signUpPasswordCheck1Event);
    on<SignUpDataCollectedEvent> (signUpDataCollectedEvent);
  }

}




