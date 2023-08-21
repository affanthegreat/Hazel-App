part of 'settings_bloc.dart';

@immutable
abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState{}

class SettingsLoaded extends SettingsState {}

class LoadUserBlockedAccounts extends SettingsState {
  final Set<UserProfileModel?> listOfUsers;
  LoadUserBlockedAccounts(this.listOfUsers);

}
class SettingsError extends SettingsState {}