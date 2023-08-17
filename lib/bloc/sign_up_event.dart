part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpEvent {}


class SignUpStartEvent extends SignUpEvent{}

class SignUpEmailAddedEvent extends SignUpEvent{
  final String email;
  SignUpEmailAddedEvent(this.email);
}

class SignUpUserNameEvent extends SignUpEvent{
  final String userName;

  SignUpUserNameEvent(this.userName);

}

class SignUpPasswordCheck1Event extends SignUpEvent{
  final String password;

  SignUpPasswordCheck1Event(this.password);

}

class SignUpDataCollectedEvent extends SignUpEvent{
  final String password;
  final String email;
  final String userName;

  SignUpDataCollectedEvent(this.password, this.email, this.userName);
}