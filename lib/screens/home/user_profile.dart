import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hazel_client/logics/wrappers.dart';
import 'package:hazel_client/widgets/HazelFieldHeading.dart';
import 'package:hazel_client/widgets/leafWidget.dart';
import 'package:hazel_client/bloc/user_profile/user_profile_bloc.dart';
import 'package:hazel_client/constants/colors.dart';
import 'package:hazel_client/logics/UserProfileModel.dart';
import 'package:hazel_client/logics/user_engine.dart';
import 'package:hazel_client/main.dart';
import 'package:hive/hive.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:hazel_client/widgets/HazelMetricWidget.dart';
import 'package:intl/intl.dart';

import '../../logics/LeafModel.dart';
import '../../widgets/HazelFieldLabel.dart';



UserProfileBloc userProfileBloc = UserProfileBloc();

class UserProfile extends StatefulWidget {
  late bool profileVisit;
  UserProfileModel? userObj;
  UserProfile({super.key, required this.profileVisit, this.userObj});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  final TextEditingController searchFieldController = TextEditingController();

  String getLatestString() {
    if (searchFieldController.text.isEmpty) {
      userProfileBloc.add(UserProfileOnBeginEvent(true));
    } else if (searchFieldController.text.length > 1) {
      userProfileBloc.add(UserProfileSearchEvent(searchFieldController.text, 1));
    }
    return searchFieldController.text;
  }

  double savedUserPageScrollOffset = 0;
  ScrollController followersScrollController = ScrollController();
  ScrollController followRequestScrollController = ScrollController();
  ScrollController followingScrollController = ScrollController();

  @override
  void initState() {
    print("------------------");
    print(widget.profileVisit);
    if(widget.profileVisit){
      print("======================");
      print("PROFILE VISIT EVENT");
      userProfileBloc.add(UserProfileVisitEvent(widget.userObj!));
    } else{
      userProfileBloc.add(UserProfileOnBeginEvent(false));
    }
    searchFieldController.addListener(getLatestString);
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    searchFieldController.dispose();
    super.dispose();
  }

  Widget searchUserField() {
    return Container(
      margin: const EdgeInsets.only(top: 0, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: isDarkTheme ? Colors.pinkAccent.shade700 : Colors.pinkAccent.shade200, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 10,
        ),
        child: TextField(
          controller: searchFieldController,
          maxLength: 400,
          style: GoogleFonts.sourceSansPro(
            textStyle: Theme.of(context).textTheme.bodyLarge,
            color: isDarkTheme ? Colors.white : Colors.black,
          ),
          maxLines: null,
          decoration: InputDecoration(
              counterText: '',
              prefixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints:const  BoxConstraints(),
                    icon: Icon(
                      Icons.search,
                      color: isDarkTheme ? Colors.pinkAccent : Colors.pinkAccent.shade700,
                      size: 24,
                    ),
                    onPressed: () {
                      if (searchFieldController.text.isNotEmpty) {
                        userProfileBloc.add(UserProfileSearchEvent(searchFieldController.text, 1));
                      } else {
                        var snackBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            "Looks like you haven't entered any user name in there. Try again.",
                            style: GoogleFonts.inter(
                              textStyle: Theme.of(context).textTheme.bodyMedium,
                              color: Colors.white,
                            ),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                  ),
                ],
              ),
              border: InputBorder.none,
              hintText: "Find your friends..",
              hintStyle: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodyMedium,
                color: isDarkTheme ? Colors.grey : Colors.grey.shade700,
              )),
        ),
      ),
    );
  }

  String numToEng(int num) {
    if (num >= 1000000) {
      return (num / 1000000).toStringAsFixed(1) + ' mil';
    } else if (num >= 1000) {
      return (num / 1000).toStringAsFixed(1) + 'k';
    } else {
      return num.toString();
    }
  }

  String dateTimeToWords(String dateTimeStr) {
    var dateTime = DateTime.parse(dateTimeStr);
    var formatter = DateFormat('MMMM d, y h:mm a');
    return formatter.format(dateTime.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    var isPublicSelected = true;
    Widget tabSwitcher() {
      return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        decoration: BoxDecoration(color: isDarkTheme ? Colors.grey.shade900.withOpacity(0.6) : Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: isPublicSelected ? CupertinoColors.activeBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: InkWell(
                  onTap: () {
                    isPublicSelected = true;
                    userProfileBloc.add(UserProfileOnBeginEvent(true));
                  },
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.public,
                          color: isPublicSelected ? Colors.white : Colors.grey,
                          size: 21,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 3),
                          child: Text(
                            "Public Leaves",
                            style: GoogleFonts.inter(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                              fontWeight: FontWeight.bold,
                              color: isPublicSelected ? CupertinoColors.white : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 40,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(color: !isPublicSelected ? Colors.greenAccent : Colors.transparent, borderRadius: BorderRadius.circular(5)),
                child: InkWell(
                  onTap: () {
                    isPublicSelected = false;
                    userProfileBloc.add(UserProfileOnBeginEvent(true));
                  },
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.security,
                          color: !isPublicSelected ? Colors.black : Colors.grey,
                          size: 21,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 3),
                          child: Text(
                            "Private Leaves",
                            style: GoogleFonts.inter(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                              fontWeight: FontWeight.bold,
                              color: !isPublicSelected ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget userMetricSection(UserProfileModel obj) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HazelFieldHeading(text: obj!.userFullName!),
          Text("@" + obj!.userName!,
              textAlign: TextAlign.left,
              style: GoogleFonts.inter(
                color: isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade400,
                textStyle: Theme.of(context).textTheme.labelLarge,
              )),
          Text(obj!.userBio!,
              textAlign: TextAlign.left,
              style: GoogleFonts.inter(
                height: 1.3,
                letterSpacing:-0.1,
                color: isDarkTheme ? Colors.grey.shade200 : Colors.grey.shade900,
                textStyle: Theme.of(context).textTheme.bodyLarge,
              )),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                HazelMetricWidget(label: "Total Leaves", value: numToEng(obj.userPublicLeafCount! + obj.userPrivateLeafCount!).toString(), color: CupertinoColors.activeBlue),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      var box = await Hive.openBox('logged-in-user');
                      var user_obj = box.get('user_obj');
                      if(obj.userId == user_obj.userId){
                        userProfileBloc.followingPage = 1;
                        userProfileBloc.add(UserProfileSeeFollowingEvent(user_obj.userId));
                      } else{
                        userProfileBloc.followingPage = 1;
                        userProfileBloc.add(UserProfileSeeFollowingEvent(obj.userId!));
                      }

                    },
                    child: HazelMetricWidget(
                      label: "Following",
                      value: numToEng(obj.userFollowing!).toString(),
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      var box = await Hive.openBox('logged-in-user');
                      var user_obj = box.get('user_obj');
                      if(obj.userId == user_obj.userId){
                        userProfileBloc.followersPage = 1;
                        userProfileBloc.add(UserProfileSeeFollowersEvent(user_obj.userId));
                      } else{
                        userProfileBloc.followersPage = 1;
                        userProfileBloc.add(UserProfileSeeFollowersEvent(obj.userId!));
                      }

                    },
                    child: HazelMetricWidget(label: "Followers", value: numToEng(obj.userFollowers!).toString(), color: CupertinoColors.activeBlue),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: HazelMetricWidget(
                  label: "Experience points",
                  value: numToEng(obj.userExperiencePoints!),
                  color: CupertinoColors.systemYellow,
                ),
              ),
              SizedBox(
                width: 100,
                child: HazelMetricWidget(
                  label: "Level",
                  value: (obj.userLevel!).toString(),
                  color: CupertinoColors.systemYellow,
                ),
              ),
            ],
          ),
        ],
      );
    }

    Widget leavesSection(Set<LeafModel?> publicLeafSet, Set<LeafModel?> privateLeafSet, UserProfileModel? obj) {
      return (isPublicSelected && publicLeafSet.isEmpty)
          ? SliverToBoxAdapter(
              key: const ValueKey<int>(3),
              child: SizedBox(
                height: 100,
                child: Center(
                  child: Text("No public leaves found.",
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.labelMedium,
                        color: Colors.grey,
                      )),
                ),
              ),
            )
          : (!isPublicSelected && privateLeafSet.isEmpty)
              ? SliverToBoxAdapter(
                  key: const ValueKey<int>(2),
                  child: SizedBox(
                    height: 100,
                    child: Center(
                      child: Text("No private leaves found.",
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.labelMedium,
                            color: Colors.grey,
                          )),
                    ),
                  ))
              : SliverList(
                  key: const ValueKey<int>(1),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return isPublicSelected ? HazelLeafWidget(leaf_obj: publicLeafSet.elementAt(index), user_obj: obj) : HazelLeafWidget(leaf_obj: privateLeafSet.elementAt(index), user_obj: obj);
                  }, childCount: isPublicSelected ? publicLeafSet.length : privateLeafSet.length),
                );
    }

    Widget AllLeavesSection(Set<LeafModel?> leaves, UserProfileModel? obj) {
      return (leaves.isEmpty)
          ? SliverToBoxAdapter(
              key: const ValueKey<int>(4),
              child: SizedBox(
                height: 100,
                child: Center(
                  child: Text("No leaves found.",
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.labelMedium,
                        color: Colors.grey,
                      )),
                ),
              ))
          : SliverList(
              key: const ValueKey<int>(5),
              delegate: SliverChildBuilderDelegate((context, index) {
                return HazelLeafWidget(leaf_obj: leaves.elementAt(index), user_obj: obj);
              }, childCount: leaves.length),
            );
    }

    Widget expProgressMeter(UserProfileModel? obj) {
      return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: LinearPercentIndicator(
          lineHeight: 40.0,
          percent: obj!.userExperiencePoints! / obj!.experienceNeededForLevelUp(obj!.userExperiencePoints!) ,
          backgroundColor: isDarkTheme ? Colors.grey.shade900.withOpacity(0.5) : Colors.grey.shade200,
          animation: true,
          barRadius: const Radius.circular(8),
          alignment: MainAxisAlignment.center,
          center: Text(
            "${obj!.experienceNeededForLevelUp(obj!.userExperiencePoints!).toInt() - (obj!.userExperiencePoints)!.toInt()} points needed to level up",
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.labelMedium,
              fontWeight: FontWeight.bold,
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          trailing: Text(
            "${numToEng(obj!.experienceNeededForLevelUp(obj!.userExperiencePoints!).toInt())}",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              textStyle: Theme.of(context).textTheme.bodyMedium,
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          padding: const EdgeInsets.only(right: 10, left: 2),
          linearGradient: const LinearGradient(
            colors: [

              CupertinoColors.systemGreen,
              CupertinoColors.systemGreen
            ],
          ),
        ),
      );
    }

    Widget userProfilePage(UserProfileSuccessfulLoading state) {
      print(state.obj!.userId);
      return Scaffold(
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        appBar: AppBar(
          toolbarHeight: 80,
          title: searchUserField(),
          backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
          actions: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints:const  BoxConstraints(),
                  onPressed: () {
                    userProfileBloc.followReqestsPage = 1;
                    userProfileBloc.add(UserProfileViewFollowRequestsEvent());
                  },
                  icon: const Icon(Iconsax.safe_home)),
            ),
          ],
        ),
        body: RefreshIndicator(
          backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
          onRefresh: () async {
            userProfileBloc.privateLeafPage = 1;
            userProfileBloc.publicLeafPage = 1;
            userProfileBloc.publicLeavesPost = {};
            userProfileBloc.privateLeafPost = {};
            userProfileBloc.add(UserProfileOnBeginEvent(true));
          },
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [userMetricSection(state.obj!), expProgressMeter(state.obj!)],
                    ),
                  ),
                  tabSwitcher(),
                ]),
              ),
              leavesSection(state.publicLeafSet!, state.privateLeafSet!, state.obj!)
            ],
          ),
        ),
      );
    }

    Widget scaffoldError() {
      return Scaffold(
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        appBar: AppBar(
          toolbarHeight: 80,
          leading: IconButton(
            padding: EdgeInsets.zero,
            constraints:const  BoxConstraints(),
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if(widget.profileVisit){
                Navigator.pop(context);
              } else{
                searchFieldController.clear();
                userProfileBloc.publicLeafPage = 1;
                userProfileBloc.privateLeafPage = 1;
                userProfileBloc.privateLeafPost = {};
                userProfileBloc.publicLeavesPost = {};
                userProfileBloc.add(UserProfileOnBeginEvent(true));
              }

            },
          ),
          title: searchUserField(),
          backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        ),
        body: Center(
          child: Text(
            "Some error occurred.",
            style: GoogleFonts.inter(
              textStyle: Theme.of(context).textTheme.bodyMedium,
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
        ),
      );
    }

    Widget followBackButton(state) {
      return Container(
          height: 40,
          margin: const EdgeInsets.only(right: 2.5, top: 10, bottom: 10),
          decoration: BoxDecoration(color: CupertinoColors.activeBlue, borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            onTap: () {
              userProfileBloc.add(UserProfileSendFollowRequestEvent(state.obj, state.follow_map));
            },
            child: Center(
              child: Text("Follow back", style: GoogleFonts.inter(textStyle: Theme.of(context).textTheme.bodyMedium, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ));
    }

    Widget removeFollowerButton(state) {
      return Container(
          height: 40,
          margin: const EdgeInsets.only(left: 2.5, top: 10, bottom: 10),
          decoration: BoxDecoration(color: isDarkTheme ? Colors.grey.shade900 : Colors.grey.shade900, borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            onTap: () async {
              var box = await Hive.openBox('logged-in-user');
              var user_obj = box.get('user_obj');
              userProfileBloc.add(UserProfileRemoveFollower(user_obj!.userId, state!.obj.userId, state!.obj));
            },
            child: Center(
              child: Text("Remove",
                  style: GoogleFonts.inter(
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme ? hazelLogoColorLight : hazelLogoColor,
                  )),
            ),
          ));
    }

    Widget unfollowButton(state) {
      return Container(
          height: 40,
          margin: const EdgeInsets.only(right: 2.5, top: 10, bottom: 10),
          decoration: BoxDecoration(color: isDarkTheme ? Colors.grey.shade900 : Colors.grey.shade900, borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            onTap: () async {
              var box = await Hive.openBox('logged-in-user');
              var user_obj = box.get('user_obj');
              userProfileBloc.add(UserProfileRemoveFollower(state!.obj.userId, user_obj!.userId, state!.obj));
            },
            child: Center(
              child: Text("Unfollow", style: GoogleFonts.inter(textStyle: Theme.of(context).textTheme.bodyMedium, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ));
    }

    Widget followRequestedInfoButton(state) {
      return Container(
          height: 40,
          margin: const EdgeInsets.only(right: 2.5, top: 10, bottom: 10),
          decoration: BoxDecoration(color: isDarkTheme ? Colors.grey.shade900 : Colors.grey.shade900, borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            onTap: () {
              userProfileBloc.add(UserProfileRemoveFollowRequestEvent(state.obj, state.follow_map));
            },
            child: Center(
              child: Text("Follow requested", style: GoogleFonts.inter(textStyle: Theme.of(context).textTheme.bodyMedium, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ));
    }

    Widget userCard(UserProfileModel? obj) {
      return Container(
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        decoration: BoxDecoration(color: isDarkTheme ? Colors.grey.shade900.withOpacity(0.3) : Colors.grey.shade50, border: Border.all(color: isDarkTheme ? Colors.grey.shade900 : Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HazelFieldHeading(text: obj!.userFullName!),
                  Text("@" + obj!.userName!,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.inter(
                        color: isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade400,
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      )),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: HazelMetricWidget(label: "Followers", value: obj.userFollowers.toString(), color: CupertinoColors.activeBlue)),
                  Expanded(child: HazelMetricWidget(label: "Level", value: obj.userLevel.toString(), color: CupertinoColors.activeBlue)),
                  Expanded(child: HazelMetricWidget(label: "Exp points", value: obj.userExperiencePoints.toString(), color: CupertinoColors.activeBlue))
                ],
              ),
            ),
            Container(
              height: 40,
              margin: const EdgeInsets.only(right: 10, bottom: 15, left: 10),
              decoration: BoxDecoration(color: isDarkTheme ? Colors.grey.shade900.withOpacity(0.5) : Colors.grey.shade100, border: Border.all(color: isDarkTheme ? Colors.black : Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
              child: InkWell(
                onTap: () {
                  userProfileBloc.leavesPage = 1;
                  userProfileBloc.leavesSet = {};
                  userProfileBloc.add(UserProfileVisitEvent(obj));
                },
                child: Center(
                  child: Text(
                    "Visit profile",
                    style: GoogleFonts.inter(textStyle: Theme.of(context).textTheme.labelLarge, fontWeight: FontWeight.bold, color: isDarkTheme ? Colors.white : Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget userFollowRequestCard(UserProfileShowAllFollowRequests state, UserProfileModel? obj) {
      return Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        decoration: BoxDecoration(color: isDarkTheme ? Colors.grey.shade900.withOpacity(0.3) : Colors.grey.shade100, border: Border.all(color: isDarkTheme ? Colors.grey.shade900 : Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
                onTap: () {
                  userProfileBloc.add(UserProfileVisitEvent(obj));
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HazelFieldHeading(text: obj!.userFullName!),
                      Text("@" + obj!.userName!,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.inter(
                            color: isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade400,
                            textStyle: Theme.of(context).textTheme.labelLarge,
                          )),
                    ],
                  ),
                )),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.only(right: 2.5, bottom: 15, left: 10),
                    decoration: BoxDecoration(color: isDarkTheme ? CupertinoColors.activeBlue : Colors.grey.shade100, border: Border.all(color: isDarkTheme ? Colors.black : Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                    child: InkWell(
                      onTap: () {
                        userProfileBloc.add(UserAcceptFollowRequest(obj));
                      },
                      child: Center(
                        child: Text(
                          "Accept",
                          style: GoogleFonts.inter(textStyle: Theme.of(context).textTheme.labelMedium, fontWeight: FontWeight.bold, color: isDarkTheme ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.only(right: 10, bottom: 15, left: 2.5),
                    decoration: BoxDecoration(color: isDarkTheme ? Colors.grey.shade900.withOpacity(0.5) : Colors.grey.shade100, border: Border.all(color: isDarkTheme ? Colors.black : Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                    child: InkWell(
                      onTap: () async {

                        print(obj!.userName);
                        var box = await Hive.openBox('logged-in-user');
                        var user_obj = box.get('user_obj');
                       var status =  await UserEngine().denyFollowRequest({'requested_to': user_obj.userId,
                                                                            'requester': obj.userId});
                       print(status);
                        var following_status = await UserEngine().getFollowingStatus({'search_profile_id': obj.userId});
                        userProfileBloc.followReqestsPage = 1;
                        userProfileBloc.add(UserProfileViewFollowRequestsEvent());
                      },
                      child: Center(
                        child: Text(
                          "Deny",
                          style: GoogleFonts.inter(textStyle: Theme.of(context).textTheme.labelLarge, fontWeight: FontWeight.bold, color: isDarkTheme ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget noFollowRequestsScaffold() {
      return Scaffold(
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        appBar: AppBar(
          toolbarHeight: 80,
          leading: IconButton(
            padding: EdgeInsets.zero,
            constraints:const  BoxConstraints(),
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if(widget.profileVisit){
                Navigator.pop(context);
              } else{
                searchFieldController.clear();
                userProfileBloc.publicLeafPage = 1;
                userProfileBloc.privateLeafPage = 1;
                userProfileBloc.privateLeafPost = {};
                userProfileBloc.publicLeavesPost = {};
                userProfileBloc.add(UserProfileOnBeginEvent(true));
              }

            },
          ),
          title: Text(
            "Follow requests",
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.bodyLarge,
              fontWeight: FontWeight.bold,
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        ),
        body: Center(
          child: Text(
            "Looks like you have no pending follow requests.",
            style: GoogleFonts.inter(
              textStyle: Theme.of(context).textTheme.bodyMedium,
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
        ),
      );
    }

    Widget noFollowersScaffold() {
      return Scaffold(
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        appBar: AppBar(
          toolbarHeight: 80,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            padding: EdgeInsets.zero,
            constraints:const  BoxConstraints(),
            onPressed: () {
              if(widget.profileVisit){
                Navigator.pop(context);
              } else{
                searchFieldController.clear();
                userProfileBloc.publicLeafPage = 1;
                userProfileBloc.privateLeafPage = 1;
                userProfileBloc.privateLeafPost = {};
                userProfileBloc.publicLeavesPost = {};
                userProfileBloc.add(UserProfileOnBeginEvent(true));
              }

            },
          ),
          title: Text(
            "Your followers",
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.bodyLarge,
              fontWeight: FontWeight.bold,
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        ),
        body: Center(
          child: Text(
            "Looks like you have no followers.",
            style: GoogleFonts.inter(
              textStyle: Theme.of(context).textTheme.bodyMedium,
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
        ),
      );
    }

    Widget noFollowingScaffold() {
      return Scaffold(
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        appBar: AppBar(
          toolbarHeight: 80,
          leading: IconButton(
            padding: EdgeInsets.zero,
            constraints:const  BoxConstraints(),
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if(widget.profileVisit){
                Navigator.pop(context);
              } else{
                searchFieldController.clear();
                userProfileBloc.publicLeafPage = 1;
                userProfileBloc.privateLeafPage = 1;
                userProfileBloc.privateLeafPost = {};
                userProfileBloc.publicLeavesPost = {};
                userProfileBloc.add(UserProfileOnBeginEvent(true));
              }

            },
          ),
          title: Text(
            "Your following",
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.bodyLarge,
              fontWeight: FontWeight.bold,
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        ),
        body: Center(
          child: Text(
            "Looks like you have no one following you.",
            style: GoogleFonts.inter(
              textStyle: Theme.of(context).textTheme.bodyMedium,
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
        ),
      );
    }

    Widget followButton(state) {
      return Container(
        height: 40,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(color: CupertinoColors.activeBlue, borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: () {
            userProfileBloc.add(UserProfileSendFollowRequestEvent(state.obj, state.follow_map));
          },
          child: Center(
            child: Text("Follow", style: GoogleFonts.inter(textStyle: Theme.of(context).textTheme.bodyMedium, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      );
    }

    Widget blockButton(String txt) {
      return Container(
        margin: const EdgeInsets.all(10),
        height: 50,
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isDarkTheme ? Colors.grey.shade900.withOpacity(0.5) : Colors.grey.shade700,
        ),
        child: Center(
          child: Text(txt, style: GoogleFonts.inter(textStyle: Theme.of(context).textTheme.bodySmall, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      );
    }

    AppBar titleAppBar(String title) {
      return AppBar(
        toolbarHeight: 80,
        leading: IconButton(
          padding: EdgeInsets.zero,
          constraints:const  BoxConstraints(),
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if(widget.profileVisit){
              Navigator.pop(context);
            } else{
              searchFieldController.clear();
              userProfileBloc.add(UserProfileOnBeginEvent(false));
            }

          },
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            textStyle: Theme.of(context).textTheme.bodyLarge,
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
      );
    }

    Widget scaffoldFollowing(state) {
      return Scaffold(
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        appBar: titleAppBar("Following"),
        body: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification) {
              if (followingScrollController.position.extentAfter == 0) {
                userProfileBloc.add(UserProfileSeeFollowingEvent(state.userId));
              }
            }
            return false;
          },
          child: ListView.builder(
            itemCount: state.listOfUsers.length,
            itemBuilder: (context, index) {
              return userCard(state.listOfUsers.elementAt(index));
            },
            controller: followingScrollController,
          ),
        ),
      );
    }


    Widget scaffoldFollowers(state) {
      return Scaffold(
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        appBar: titleAppBar("Followers"),
        body: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification) {
              if (followersScrollController.position.extentAfter == 0) {
                userProfileBloc.add(UserProfileSeeFollowersEvent(state.userId));
              }
            }
            return false;
          },
          child: ListView.builder(
            itemCount: state.listOfUsers.length,
            itemBuilder: (context, index) {
              return userCard(state.listOfUsers.elementAt(index));
            },
            controller: followersScrollController,
          ),
        ),
      );
    }


    Widget scaffoldFollowRequests(state) {
      return Scaffold(
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        appBar: titleAppBar("Follow Requests"),
        body: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification) {
              if (followRequestScrollController.position.extentAfter == 0) {
                userProfileBloc.add(UserProfileViewFollowRequestsEvent());
              }
            }
            return false;
          },
          child: ListView.builder(
            itemCount: state.listOfUsers.length,
            itemBuilder: (context, index) {
              return userFollowRequestCard(state, state.listOfUsers.elementAt(index));
            },
            controller: followRequestScrollController,
          ),
        ),
      );
    }


    Widget scaffoldLoading(state) {
      return Scaffold(
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        appBar: AppBar(
          toolbarHeight: 80,
          title: searchUserField(),
          backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
          actions: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints:const  BoxConstraints(),
                  onPressed: () {
                    userProfileBloc.followReqestsPage = 1;
                    userProfileBloc.add(UserProfileViewFollowRequestsEvent());
                  },
                  icon: const Icon(Iconsax.safe_home)),
            ),
          ],
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return BlocConsumer<UserProfileBloc, UserProfileState>(
        bloc: userProfileBloc,
        listener: (context, state) {
          if (state is UserProfileErrorLoading) {
            var snackBar = SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'Something went wrong. Please try again.',
                style: GoogleFonts.inter(
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  color: Colors.white,
                ),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          if (state is UserProfileShowAllFollowRequests && state.listOfUsers.isEmpty) {
            return noFollowRequestsScaffold();
          }
          if (state is UserProfileShowAllFollowRequests) {
            return scaffoldFollowRequests(state);
          }

          if (state is UserProfileGetFollowersSuccesful && state.listOfUsers.isEmpty) {
            return noFollowersScaffold();
          }

          if (state is UserProfileGetFollowersSuccesful) {
            return scaffoldFollowers(state);
          }

          if (state is UserProfileGetFollowersError) {
            return scaffoldError();
          }
          if (state is UserProfileGetFollowingSuccesful && state.listOfUsers.isEmpty) {
            return noFollowingScaffold();
          }

          if (state is UserProfileGetFollowingSuccesful) {
            return scaffoldFollowing(state);
          }
          if (state is UserProfileGetFollowingError) {
            return scaffoldError();
          }

          if (state is UserProfileSearchSuccessful) {
            return Scaffold(
              backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
              appBar: AppBar(
                toolbarHeight: 80,
                leading: IconButton(
                  padding: EdgeInsets.zero,
                  constraints:const  BoxConstraints(),
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    if(widget.profileVisit){
                      Navigator.pop(context);
                    } else{
                      searchFieldController.clear();
                      userProfileBloc.publicLeafPage = 1;
                      userProfileBloc.privateLeafPage = 1;
                      userProfileBloc.add(UserProfileOnBeginEvent(false));
                    }

                  },
                ),
                title: searchUserField(),
                backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
              ),
              body: state.listOfUsers.isEmpty
                  ? Center(
                      child: Text(
                        'No Users found.',
                        style: GoogleFonts.inter(textStyle: Theme.of(context).textTheme.bodyMedium, fontWeight: FontWeight.bold, color: isDarkTheme ? Colors.white : Colors.black),
                      ),
                    )
                  : CustomScrollView(
                      slivers: [
                        SliverList(
                            delegate: SliverChildBuilderDelegate((context, index) {
                          return userCard(state.listOfUsers.elementAt(index));
                        }, childCount: state.listOfUsers.length))
                      ],
                    ),
            );
          }

          if (state is UserProfileSearchFailure) {
            return scaffoldError();
          }

          if (state is UserProfileLoading) {
            return scaffoldLoading(state);
          }

          if (state is UserProfileErrorLoading) {
            return Scaffold(
              backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
              appBar: AppBar(
                toolbarHeight: 80,
                title: searchUserField(),
                backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                actions: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints:const  BoxConstraints(),
                        onPressed: () {
                          userProfileBloc.followReqestsPage = 1;
                          userProfileBloc.add(UserProfileViewFollowRequestsEvent());
                        },
                        icon: const Icon(Iconsax.safe_home)),
                  ),
                ],
              ),
              body: RefreshIndicator(
                backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                onRefresh: () async {
                  userProfileBloc.privateLeafPage = 1;
                  userProfileBloc.publicLeafPage = 1;
                  userProfileBloc.add(UserProfileOnBeginEvent(true));
                },
                child: ListView(
                  children: [
                    Center(
                      child: Text("Something went wrong. Pull to retry.",
                          style: GoogleFonts.inter(
                            textStyle: Theme.of(context).textTheme.bodyMedium,
                            color: Colors.red,
                          )),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is UserProfileVisit) {
           check_user() async {
             var box = await Hive.openBox('logged-in-user');
             var user_obj = box.get('user_obj');
             if(state.obj == user_obj.userId){
               print("something something");
               userProfileBloc.add(UserProfileOnBeginEvent(false));
               }
             }
             check_user();
            print(state.leaves);
            print(state.follow_map);
            var isFollowRequestSent = state.follow_map['follow_request_status'];
            var isUserFollowingThisUser = state.follow_map['following_status'];
            var isUserAFollower = state.follow_map['follower_status'];
            var isUserBlocked = state.follow_map['block_status'];
            var isUserBlockedBy = state.follow_map['blocked_by_status'];

            RelationshipStatus rel_obj = RelationshipStatus(followRequestStatus:  isFollowRequestSent, followerStatus:isUserAFollower , followingStatus:isUserFollowingThisUser, blockedByStatus:isUserBlockedBy, blockStatus:isUserBlocked);
            Widget getFollowButtonLabel(RelationshipStatus status) {
              if (status.followRequestStatus) {
                return Expanded(child: followRequestedInfoButton(state));
              } else if (status.followingStatus) {
                return Expanded(child: unfollowButton(state));
              } else if (status.followerStatus) {
                return Expanded(child: followBackButton(state));
              } else {
                return Expanded(child: followButton(state));
              }
            }

            Widget getRemoveFollowerButtonLabel(RelationshipStatus status) {
              if (status.followerStatus) {
                return Expanded(child: removeFollowerButton(state));
              } else {
                return Container(); // No need to show this button
              }
            }
            return Scaffold(
              key: const ValueKey<int>(1),
              backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
              appBar: AppBar(
                backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    if(widget.profileVisit){
                      Navigator.pop(context);
                    } else{
                      searchFieldController.clear();
                      userProfileBloc.publicLeafPage = 1;
                      userProfileBloc.privateLeafPage = 1;
                      userProfileBloc.privateLeafPost = {};
                      userProfileBloc.publicLeavesPost = {};

                      userProfileBloc.add(UserProfileOnBeginEvent(false));
                    }

                  },
                ),
                actions: isUserBlockedBy
                    ? []
                    : [
                        isUserBlocked
                            ? InkWell(
                                onTap: () async {
                                  userProfileBloc.add(UserProfileUnBlockUserEvent(state.obj));
                                },
                                child: blockButton("Unblock User"))
                            : InkWell(
                                onTap: () {
                                  userProfileBloc.add(UserProfileBlockUserEvent(state.obj));
                                },
                                child: blockButton('Block User'))
                      ],
              ),
              body: isUserBlockedBy
                  ? Container(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "@" + state.obj!.userName!,
                                    style: GoogleFonts.poppins(
                                      textStyle: Theme.of(context).textTheme.headlineSmall,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkTheme ? hazelLogoColorLight : hazelLogoColor,
                                    )),
                              ]),
                            ),
                            const HazelFieldLabel(text: "This user has blocked you.")
                          ],
                        ),
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: RefreshIndicator(
                        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                        onRefresh: () async {
                          userProfileBloc.publicLeafPage = 1;
                          userProfileBloc.privateLeafPage = 1;
                          userProfileBloc.privateLeafPost = {};
                          userProfileBloc.publicLeavesPost = {};
                          userProfileBloc.add(UserProfileOnBeginEvent(true));
                        },
                        child: CustomScrollView(slivers: [
                          SliverList(
                            delegate: SliverChildListDelegate([
                              userMetricSection(state!.obj!),
                              Row(
                                children: [
                                  getFollowButtonLabel(rel_obj),
                                  getRemoveFollowerButtonLabel(rel_obj)
                                ],
                              )

                            ]),
                          ),
                          AllLeavesSection(state!.leaves!, state.obj!)
                        ]),
                      ),
                    ),
            );
          }

          if (state is UserProfileVisitError) {
            return scaffoldError();
          }
          if (state is UserProfileSuccessfulLoading) {
            return userProfilePage(state);
          }
          return Container();
        });
  }
}
