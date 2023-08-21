import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hazel_client/logics/UserProfileModel.dart';
import 'package:hazel_client/logics/user_engine.dart';
import 'package:meta/meta.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  int bloockedPageNumber = 1;
  Set<UserProfileModel?> blockedAccounts ={};

  SettingsBloc() : super(SettingsInitial()) {
   on<SettingsPageInitialLoad>(loadSettings);
   on<SettingsPageUShowBlockedAccounts>(showBlocked);
   on<SettingsPageUnblock>(unblock);
  }

  FutureOr<void> loadSettings(SettingsPageInitialLoad event, Emitter<SettingsState> emit) {
    emit(SettingsLoading());
    emit(SettingsLoaded());
  }

  FutureOr<void> showBlocked(SettingsPageUShowBlockedAccounts event, Emitter<SettingsState> emit) async{
    emit(SettingsLoaded());
    try{
      var blockedLists = await UserEngine().getBlockedAccounts(bloockedPageNumber);
      if(bloockedPageNumber == 1){
        blockedAccounts = blockedLists;
      } else{
        blockedAccounts.addAll(blockedLists);
      }
      bloockedPageNumber++;
      emit(LoadUserBlockedAccounts(blockedAccounts));
    } catch(e){
      emit(SettingsError());
    }
  }

  FutureOr<void> unblock(SettingsPageUnblock event, Emitter<SettingsState> emit) async{
    emit(SettingsLoaded());
    try {
      await UserEngine().unblockUser(
          {'blocked': event.obj!.userId});
      for(int i= 0; i< blockedAccounts.length; i++){
        if(blockedAccounts.elementAt(i)!.userId == event.obj!.userId){
          blockedAccounts.remove(blockedAccounts.elementAt(i));
        }
      }
      emit(LoadUserBlockedAccounts(blockedAccounts));
    } catch (E) {
      emit(SettingsError());
    }
  }
}
