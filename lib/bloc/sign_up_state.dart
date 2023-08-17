part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpStartSuccess extends SignUpState{
  final bool status;
  SignUpStartSuccess(this.status);
}

class SignUpEmailAddedState extends SignUpState{}

class SignUpEmailErrorState extends SignUpState{}

class SignUpUserNameAddedState extends SignUpState{}

class SignUpUserNameErrorState extends SignUpState{}

class SignUpPasswordErrorState extends SignUpState{}

class SignUpUserPasswordState extends SignUpState{}

class SignupAccountCreationLoading extends SignUpState{}

class SignupAccountCreationSuccessful extends SignUpState{}

class SignupAccountCreationError extends SignUpState{}