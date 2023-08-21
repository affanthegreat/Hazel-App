import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hazel_client/logics/LeafModel.dart';
import 'package:hazel_client/logics/UserProfileModel.dart';
import 'package:hazel_client/logics/leaf_engine.dart';
import 'package:hazel_client/logics/user_engine.dart';
import 'package:meta/meta.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {


  Set<UserProfileModel?> followersList = {};
  Set<UserProfileModel?> followingList = {};
  Set<UserProfileModel?> followingRequests = {};
  Set<LeafModel?> publicLeavesPost = {};
  Set<LeafModel?> privateLeafPost = {};
  int followersPage = 1;
  int followingPage = 1;
  int followReqestsPage = 1;
  int publicLeafPage = 1;
  int privateLeafPage = 1;


  UserProfileBloc() : super(UserProfileInitial()) {
    on<UserProfileOnBeginEvent>(userProfileSync);
    on<UserProfileSearchEvent>(userProfileSearch);
    on<UserProfileVisitEvent>(userProfileVisit);
    on<UserProfileSeeFollowersEvent>(userProfileGetFollower);
    on<UserProfileSeeFollowingEvent>(userProfileGetFollowing);
    on<UserProfileSendFollowRequestEvent>(userSendFollowRequest);
    on<UserProfileRemoveFollowRequestEvent>(userRemoveFollowRequest);
    on<UserProfileViewFollowRequestsEvent>(userViewFollowRequests);
    on<UserAcceptFollowRequest>(userAcceptFollowRequest);
    on<UserProfileRemoveFollower>(unFollow);
    on<UserProfileBlockUserEvent>(block);
    on<UserProfileUnBlockUserEvent>(unBlock);
  }

  FutureOr<void> userProfileSync(UserProfileOnBeginEvent event,
      Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    privateLeafPage = 1;
    publicLeafPage = 1;
    UserProfileModel? userObj = await UserEngine().fetchUserInfo(event.refresh);
    var public_leaf_set = await LeafEngine().getAllPublicLeaf(publicLeafPage);
    var private_leaf_set = await LeafEngine().getAllPrivateLeaf(privateLeafPage);

    if (userObj == null || userObj.userEmail == null) {
      emit(UserProfileErrorLoading());
    } else {
      if (publicLeafPage == 1 && privateLeafPage == 1) {
        publicLeavesPost = public_leaf_set;
        privateLeafPost = private_leaf_set;
      } else {
        publicLeavesPost.addAll(public_leaf_set);
        privateLeafPost.addAll(private_leaf_set);
      }
      publicLeafPage++;
      privateLeafPage++;
      emit(UserProfileSuccessfulLoading(userObj, publicLeavesPost,privateLeafPost));
    }
  }

  FutureOr<void> userProfileSearch(UserProfileSearchEvent event,
      Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      var user_list = await UserEngine().searchUserInfo({
        'search_query': event.search_query,
        'page_number': event.page_number
      });
      emit(UserProfileSearchSuccessful(user_list));
    } catch (e) {
      emit(UserProfileSearchFailure());
    }
  }

  FutureOr<void> userProfileVisit(UserProfileVisitEvent event,
      Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      var following_status = await UserEngine().getFollowingStatus(
          {'search_profile_id': event.profile!.userId});
      print(following_status);
      emit(UserProfileVisit(event.profile, following_status));
    } catch (e) {
      emit(UserProfileVisitError());
    }
  }

  FutureOr<void> userProfileGetFollower(UserProfileSeeFollowersEvent event,
      Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      var user_list = await UserEngine().getUserFollowers(
          {'page_number': followersPage});
      if (followersPage == 1) {
        followersList = user_list;
      } else {
        followersList!.addAll(user_list);
      }
      followersPage++;
      emit(UserProfileGetFollowersSuccesful(followersList));
    }
    catch (e) {
      emit(UserProfileGetFollowersError());
    }
  }

  FutureOr<void> userProfileGetFollowing(UserProfileSeeFollowingEvent event,
      Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      var user_list = await UserEngine().getUserFollowing(
          {'page_number': followingPage});
      print(user_list);
      if (followingPage == 1) {
        followingList = user_list;
      } else {
        followingList!.addAll(user_list);
      }
      followingPage++;
      emit(UserProfileGetFollowingSuccesful(followingList));
    }
    catch (e) {
      emit(UserProfileGetFollowingError());
    }
  }

  FutureOr<void> userSendFollowRequest(UserProfileSendFollowRequestEvent event,
      Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      await UserEngine().createFollowRequest(
          {'requested_to': event.obj!.userId});
      var following_status = await UserEngine().getFollowingStatus(
          {'search_profile_id': event.obj!.userId});
      emit(UserProfileVisit(event.obj!, following_status));
    } catch (E) {
      print(E);
    }
  }

  FutureOr<void> userRemoveFollowRequest(
      UserProfileRemoveFollowRequestEvent event,
      Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      await UserEngine().removeFollowRequest(
          {'requested_to': event.obj!.userId});
      var following_status = await UserEngine().getFollowingStatus(
          {'search_profile_id': event.obj!.userId});
      print(following_status);
      emit(UserProfileVisit(event.obj!, following_status));
    } catch (E) {
      print(E);
    }
  }

  FutureOr<void> userViewFollowRequests(
      UserProfileViewFollowRequestsEvent event,
      Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      var user_list = await UserEngine().getFollowRequests(
          {'page_number': followReqestsPage});
      if (followReqestsPage == 1) {
        followingRequests = user_list;
      } else {
        followingRequests!.addAll(user_list);
      }
      followReqestsPage++;
      emit(UserProfileShowAllFollowRequests(followingRequests));
    } catch (e) {
      emit(UserProfileFollowRequestsError());
    }
  }

  FutureOr<void> userAcceptFollowRequest(UserAcceptFollowRequest event, Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      await UserEngine().acceptFollowRequest(
          {'requested_to': event.obj!.userId});

      for(int i =0; i< followingRequests.length; i++){
        if(followingRequests!.elementAt(i)!.userId == event.obj!.userId){
          followingRequests.remove(followingRequests.elementAt(i));
        }
      }
      emit(UserProfileShowAllFollowRequests(followingRequests));
    } catch (E) {
      emit(UserProfileFollowRequestsError());
    }
  }

  FutureOr<void> unFollow(UserProfileRemoveFollower event, Emitter<UserProfileState> emit) async{
    emit(UserProfileLoading());
    try {
      await UserEngine().removeFollower(
          {'follower': event.followerUserId,
          'follows': event.followingUserId});

      var following_status = await UserEngine().getFollowingStatus(
          {'search_profile_id': event.obj!.userId});
      emit(UserProfileVisit(event.obj, following_status));
    } catch (E) {
      emit(UserProfileFollowRequestsError());
    }
  }

  FutureOr<void> block(UserProfileBlockUserEvent event, Emitter<UserProfileState> emit)async {
    emit(UserProfileLoading());
    try {
      await UserEngine().blockUser(
          {'blocked': event.obj!.userId});

      var following_status = await UserEngine().getFollowingStatus(
          {'search_profile_id': event.obj!.userId});
      emit(UserProfileVisit(event.obj, following_status));
    } catch (E) {
      emit(UserProfileFollowRequestsError());
    }
  }

  FutureOr<void> unBlock(UserProfileUnBlockUserEvent event, Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      await UserEngine().unblockUser(
          {'blocked': event.obj!.userId});

      var following_status = await UserEngine().getFollowingStatus(
          {'search_profile_id': event.obj!.userId});
      emit(UserProfileVisit(event.obj, following_status));
    } catch (E) {
      emit(UserProfileFollowRequestsError());
    }

  }
}
