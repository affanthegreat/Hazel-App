part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {}


class SettingsPageInitialLoad extends SettingsEvent {}

class SettingsPageUShowBlockedAccounts extends SettingsEvent{}

class SettingsPageUnblock extends SettingsEvent{
  final UserProfileModel? obj;

  SettingsPageUnblock(this.obj);

}
