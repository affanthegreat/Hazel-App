import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hazel_client/widgets/leafWidget.dart';
import 'package:hazel_client/bloc/user_profile/user_profile_bloc.dart';
import 'package:hazel_client/constants/colors.dart';
import 'package:hazel_client/logics/LeafModel.dart';
import 'package:hazel_client/logics/UserProfileModel.dart';
import 'package:hazel_client/logics/user_engine.dart';
import 'package:hazel_client/main.dart';
import 'package:hive/hive.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:hazel_client/widgets/HazelMetricWidget.dart';
import 'package:intl/intl.dart';

import '../../widgets/HazelFieldLabel.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  UserProfileBloc userProfileBloc = UserProfileBloc();
  final TextEditingController searchFieldController = TextEditingController();

  String getLatestString() {
    if (searchFieldController.text.isEmpty) {
      userProfileBloc.add(UserProfileOnBeginEvent(true));
    } else if (searchFieldController.text.length > 3) {
      userProfileBloc.add(UserProfileSearchEvent(searchFieldController.text, 1));
    }
    return searchFieldController.text;
  }

  @override
  void initState() {
    // TODO: implement initState
    userProfileBloc.add(UserProfileOnBeginEvent(true));
    super.initState();
    searchFieldController.addListener(getLatestString);
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
        border: Border.all(color: isDarkTheme ? Colors.grey.shade700 : Colors.grey, width: 2),
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
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: isDarkTheme ? Colors.white : Colors.black,
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
    Widget userProfilePage(UserProfileSuccessfulLoading state) {
      return Scaffold(
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        appBar: AppBar(
          toolbarHeight: 90,
          title: searchUserField(),
          backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
          actions: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: IconButton(
                  onPressed: () {
                    userProfileBloc.followReqestsPage = 1;
                    userProfileBloc.add(UserProfileViewFollowRequestsEvent());
                  },
                  icon: const Icon(Iconsax.safe_home)),
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: RefreshIndicator(
            backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
            onRefresh: () async {
              userProfileBloc.add(UserProfileOnBeginEvent(true));
            },
            child: CustomScrollView(
              slivers: [

                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Hello there, ",
                              style: GoogleFonts.poppins(
                                textStyle: Theme.of(context).textTheme.bodyLarge,
                                fontWeight: FontWeight.bold,
                                color: isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade600,
                              )),
                          TextSpan(
                              text: "@" + state.obj!.userName!,
                              style: GoogleFonts.poppins(
                                textStyle: Theme.of(context).textTheme.headlineSmall,
                                fontWeight: FontWeight.bold,
                                color: isDarkTheme ? hazelLogoColorLight : hazelLogoColor,
                              )),
                        ]),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          HazelMetricWidget(label: "Total Leaves", value: numToEng(state.obj!.userPublicLeafCount! + state.obj!.userPrivateLeafCount!).toString(), color: CupertinoColors.activeBlue),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                userProfileBloc.followingPage = 1;
                                userProfileBloc.add(UserProfileSeeFollowingEvent());
                              },
                              child: HazelMetricWidget(
                                label: "Following",
                                value: numToEng(state!.obj!.userFollowing!).toString(),
                                color: CupertinoColors.activeBlue,
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                userProfileBloc.followersPage = 1;
                                userProfileBloc.add(UserProfileSeeFollowersEvent());
                              },
                              child: HazelMetricWidget(label: "Followers", value: numToEng(state.obj!.userFollowers!).toString(), color: CupertinoColors.activeBlue),
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
                            value: numToEng(state!.obj!.userExperiencePoints!),
                            color: CupertinoColors.systemYellow,
                          ),
                        ),
                        Container(
                          width: 100,
                          child: HazelMetricWidget(
                            label: "Level",
                            value: (state.obj!.userLevel!).toString(),
                            color: CupertinoColors.systemYellow,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: LinearPercentIndicator(
                        lineHeight: 40.0,
                        percent: state.obj!.userExperiencePoints! / state.obj!.experienceNeededForLevelUp(state.obj!.userExperiencePoints!),
                        backgroundColor: isDarkTheme ? Colors.grey.shade900.withOpacity(0.5) : Colors.grey.shade200,
                        animation: true,
                        barRadius: const Radius.circular(8),
                        alignment: MainAxisAlignment.center,
                        center: Text(
                          "${state.obj!.experienceNeededForLevelUp(state.obj!.userExperiencePoints!).toInt() - (state.obj!.userExperiencePoints)!.toInt()} points needed to level up",
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.labelMedium,
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme ? Colors.white : Colors.black,
                          ),
                        ),
                        trailing: Text(
                          "${numToEng(state.obj!.experienceNeededForLevelUp(state.obj!.userExperiencePoints!).toInt())}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            textStyle: Theme.of(context).textTheme.bodyMedium,
                            color: isDarkTheme ? Colors.white : Colors.black,
                          ),
                        ),
                        padding: const EdgeInsets.only(right: 10, left: 2),
                        // animateFromLastPercent: true,
                        linearGradient: const LinearGradient(
                          colors: [
                            CupertinoColors.activeBlue,
                            CupertinoColors.systemYellow,
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: isDarkTheme ? Colors.grey.shade900 : Colors.grey.shade400,
                      thickness: 5,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(color: isDarkTheme ? Colors.grey.shade900.withOpacity(0.6) : Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(color: isPublicSelected ? CupertinoColors.activeBlue : Colors.grey.shade900, borderRadius: BorderRadius.circular(5)),
                              margin: EdgeInsets.only(right: 5),
                              child: InkWell(
                                onTap: () {
                                  isPublicSelected = true;
                                  userProfileBloc.add(UserProfileOnBeginEvent(true));
                                },
                                child: Center(
                                  child: Text(
                                    "Public Leaves",
                                    style: GoogleFonts.inter(
                                      textStyle: Theme.of(context).textTheme.labelMedium,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(color: !isPublicSelected ? CupertinoColors.activeBlue : Colors.grey.shade900, borderRadius: BorderRadius.circular(5)),
                              margin: EdgeInsets.only(left: 5),
                              child: InkWell(
                                onTap: () {
                                  isPublicSelected = false;
                                  userProfileBloc.add(UserProfileOnBeginEvent(true));
                                },
                                child: Center(
                                  child: Text(
                                    "Private Leaves",
                                    style: GoogleFonts.inter(
                                      textStyle: Theme.of(context).textTheme.labelMedium,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: isDarkTheme ? Colors.grey.shade900 : Colors.grey.shade400,
                      thickness: 1,
                    ),

                  ]),
                ),

                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return isPublicSelected ? HazelLeafWidget(leaf_obj: state.publicLeafSet!.elementAt(index), user_obj: state.obj) : HazelLeafWidget(leaf_obj: state.privateLeafSet!.elementAt(index), user_obj: state.obj);
                  }, childCount: isPublicSelected ? state.publicLeafSet.length : state.privateLeafSet.length),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget scaffoldError() {
      return Scaffold(
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        appBar: AppBar(
          toolbarHeight: 90,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              searchFieldController.clear();
              userProfileBloc.publicLeafPage = 1;
              userProfileBloc.privateLeafPage = 1;
              userProfileBloc.privateLeafPost = {};
              userProfileBloc.publicLeavesPost = {};
              userProfileBloc.add(UserProfileOnBeginEvent(true));
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
                    color: !isDarkTheme ? hazelLogoColorLight : hazelLogoColor,
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

    Widget alreadyFollowingInfoButton() {
      return Container(
        height: 40,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(color: CupertinoColors.systemGrey, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text("Already following..",
              style: GoogleFonts.inter(
                textStyle: Theme.of(context).textTheme.bodyMedium,
                fontWeight: FontWeight.bold,
                color: !isDarkTheme ? hazelLogoColorLight : hazelLogoColor,
              )),
        ),
      );
    }

    Widget userCard(UserProfileModel? obj) {
      return Container(
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        decoration: BoxDecoration(color: isDarkTheme ? Colors.grey.shade900.withOpacity(0.3) : Colors.grey.shade50, border: Border.all(color: isDarkTheme ? Colors.grey.shade900 : Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 10, left: 10),
              child: Text(
                "@" + obj!.userName.toString(),
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                  fontWeight: FontWeight.bold,
                  color: isDarkTheme ? Colors.white : Colors.black,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: HazelMetricWidget(label: "Followers", value: obj!.userFollowers.toString(), color: CupertinoColors.activeBlue)),
                  Expanded(child: HazelMetricWidget(label: "Level", value: obj!.userLevel.toString(), color: CupertinoColors.activeBlue)),
                  Expanded(child: HazelMetricWidget(label: "Exp points", value: obj!.userExperiencePoints.toString(), color: CupertinoColors.activeBlue))
                ],
              ),
            ),
            Container(
              height: 40,
              margin: const EdgeInsets.only(right: 10, bottom: 15, left: 10),
              decoration: BoxDecoration(color: isDarkTheme ? Colors.grey.shade900.withOpacity(0.5) : Colors.grey.shade100, border: Border.all(color: isDarkTheme ? Colors.black : Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
              child: InkWell(
                onTap: () {
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
          children: [
            InkWell(
              onTap: () {
                userProfileBloc.add(UserProfileVisitEvent(obj));
              },
              child: Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                child: Text(
                  "@" + obj!.userName.toString(),
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
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
                        await UserEngine().removeFollowRequest({'requested_to': obj.userId});
                        var following_status = await UserEngine().getFollowingStatus({'search_profile_id': obj!.userId});
                        print(following_status);
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
          toolbarHeight: 90,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            padding: EdgeInsets.zero,
            onPressed: () {
              searchFieldController.clear();
              userProfileBloc.publicLeafPage = 1;
              userProfileBloc.privateLeafPage = 1;
              userProfileBloc.privateLeafPost = {};
              userProfileBloc.publicLeavesPost = {};
              userProfileBloc.add(UserProfileOnBeginEvent(true));
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
          toolbarHeight: 90,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            padding: EdgeInsets.zero,
            onPressed: () {
              searchFieldController.clear();
              userProfileBloc.publicLeafPage = 1;
              userProfileBloc.privateLeafPage = 1;
              userProfileBloc.privateLeafPost = {};
              userProfileBloc.publicLeavesPost = {};
              userProfileBloc.add(UserProfileOnBeginEvent(true));
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
          toolbarHeight: 90,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              searchFieldController.clear();
              userProfileBloc.publicLeafPage = 1;
              userProfileBloc.privateLeafPage = 1;
              userProfileBloc.privateLeafPost = {};
              userProfileBloc.publicLeavesPost = {};
              userProfileBloc.add(UserProfileOnBeginEvent(true));
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
        margin: EdgeInsets.all(10),
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
            return Scaffold(
                backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                appBar: AppBar(
                  toolbarHeight: 90,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      searchFieldController.clear();
                      userProfileBloc.publicLeafPage = 1;
                      userProfileBloc.privateLeafPage = 1;
                      userProfileBloc.privateLeafPost = {};
                      userProfileBloc.publicLeavesPost = {};
                      userProfileBloc.add(UserProfileOnBeginEvent(true));
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
                body: CustomScrollView(
                  slivers: [
                    SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                      return userFollowRequestCard(state, state.listOfUsers!.elementAt(index));
                    }, childCount: state.listOfUsers!.length))
                  ],
                ));
          }

          if (state is UserProfileGetFollowersSuccesful && state.listOfUsers.isEmpty) {
            return noFollowersScaffold();
          }

          if (state is UserProfileGetFollowersSuccesful) {
            return Scaffold(
              backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
              appBar: AppBar(
                toolbarHeight: 90,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    searchFieldController.clear();
                    userProfileBloc.publicLeafPage = 1;
                    userProfileBloc.privateLeafPage = 1;
                    userProfileBloc.privateLeafPost = {};
                    userProfileBloc.publicLeavesPost = {};
                    userProfileBloc.add(UserProfileOnBeginEvent(true));
                  },
                ),
                title: Text(
                  "Your Followers",
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
                backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
              ),
              body: CustomScrollView(
                slivers: [
                  SliverList(delegate: SliverChildBuilderDelegate((context, index) {
                    return userCard(state.listOfUsers!.elementAt(index));
                  },childCount: state.listOfUsers!.length))
                ],
              ),
            );
          }

          if (state is UserProfileGetFollowersError) {
            return scaffoldError();
          }
          if (state is UserProfileGetFollowingSuccesful && state.listOfUsers.isEmpty) {
            return noFollowingScaffold();
          }

          if (state is UserProfileGetFollowingSuccesful) {
            return Scaffold(
              backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
              appBar: AppBar(
                toolbarHeight: 90,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    searchFieldController.clear();
                    userProfileBloc.publicLeafPage = 1;
                    userProfileBloc.privateLeafPage = 1;
                    userProfileBloc.privateLeafPost = {};
                    userProfileBloc.publicLeavesPost = {};
                    userProfileBloc.add(UserProfileOnBeginEvent(true));
                  },
                ),
                title: Text(
                  "Your Following",
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
                backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
              ),
              body: CustomScrollView(
                slivers: [
                  SliverList(delegate: SliverChildBuilderDelegate((context, index) {
                    return userCard(state.listOfUsers!.elementAt(index));
                  }, childCount: state.listOfUsers!.length))
                ],
              ),
            );
          }

          if (state is UserProfileGetFollowingError) {
            return scaffoldError();
          }

          if (state is UserProfileSearchSuccessful) {
            return Scaffold(
              backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
              appBar: AppBar(
                toolbarHeight: 90,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    searchFieldController.clear();
                    userProfileBloc.publicLeafPage = 1;
                    userProfileBloc.privateLeafPage = 1;
                    userProfileBloc.privateLeafPost = {};
                    userProfileBloc.publicLeavesPost = {};
                    userProfileBloc.add(UserProfileOnBeginEvent(true));
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
                        SliverList(delegate: SliverChildBuilderDelegate((context, index) {
                          return userCard(state.listOfUsers!.elementAt(index));
                        }, childCount: state.listOfUsers!.length))
                      ],
                    ),
            );
          }

          if (state is UserProfileSearchFailure) {
            return scaffoldError();
          }

          if (state is UserProfileLoading) {
            return Scaffold(
              backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
              appBar: AppBar(
                toolbarHeight: 90,
                title: searchUserField(),
                backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                actions: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: IconButton(
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

          if (state is UserProfileErrorLoading) {
            return Scaffold(
              backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
              appBar: AppBar(
                toolbarHeight: 90,
                title: searchUserField(),
                backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                actions: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: IconButton(
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
            var isFollowRequestSent = state.follow_map['follow_request_status'];
            var isUserFollowingThisUser = state.follow_map['following_status'];
            var isUserAFollower = state.follow_map['follower_status'];
            var isUserBlocked = state.follow_map['block_status'];
            var isUserBlockedBy = state.follow_map['blocked_by_status'];
            print(state.follow_map);
            return Scaffold(
              backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
              appBar: AppBar(
                backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    searchFieldController.clear();
                    userProfileBloc.publicLeafPage = 1;
                    userProfileBloc.privateLeafPage = 1;
                    userProfileBloc.privateLeafPost = {};
                    userProfileBloc.publicLeavesPost = {};
                    print("here");
                    print(userProfileBloc.privateLeafPost.length);
                    print(userProfileBloc.publicLeavesPost.length);

                    userProfileBloc.add(UserProfileOnBeginEvent(true));
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
                        margin: EdgeInsets.only(left: 10, right: 10),
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
                        child: ListView(
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "This belongs to ",
                                    style: GoogleFonts.poppins(
                                      textStyle: Theme.of(context).textTheme.headlineSmall,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade600,
                                    )),
                                TextSpan(
                                    text: "@" + state.obj!.userName!,
                                    style: GoogleFonts.poppins(
                                      textStyle: Theme.of(context).textTheme.headlineSmall,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkTheme ? hazelLogoColorLight : hazelLogoColor,
                                    )),
                              ]),
                            ),
                            Row(
                              children: [
                                HazelMetricWidget(label: "Total Leaves", value: (state.obj!.userPublicLeafCount! + state.obj!.userPrivateLeafCount!).toString(), color: CupertinoColors.activeBlue),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {},
                                    child: HazelMetricWidget(
                                      label: "Following",
                                      value: (state.obj!.userFollowing).toString(),
                                      color: CupertinoColors.activeBlue,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {},
                                    child: HazelMetricWidget(label: "Followers", value: (state.obj!.userFollowers).toString(), color: CupertinoColors.activeBlue),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: HazelMetricWidget(
                                    label: "Experience points",
                                    value: ((state.obj!.userExperiencePoints)!.toInt()).toString(),
                                    color: CupertinoColors.systemYellow,
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  child: HazelMetricWidget(label: "Level", value: (state.obj!.userLevel!).toString(), color: isDarkTheme ? CupertinoColors.systemYellow : CupertinoColors.systemYellow),
                                ),
                              ],
                            ),
                            (isUserBlocked)
                                ? Container()
                                : (isUserAFollower && isUserFollowingThisUser)
                                    ? Row(
                                        children: [Expanded(child: unfollowButton(state)), Expanded(child: removeFollowerButton(state))],
                                      )
                                    : (!isUserAFollower && isUserFollowingThisUser && !isFollowRequestSent)
                                        ? Row(
                                            children: [Expanded(child: followBackButton(state)), Expanded(child: removeFollowerButton(state))],
                                          )
                                        : (!isUserAFollower && isUserFollowingThisUser && isFollowRequestSent)
                                            ? Row(
                                                children: [Expanded(child: followRequestedInfoButton(state)), Expanded(child: removeFollowerButton(state))],
                                              )
                                            : (isUserAFollower && !isUserFollowingThisUser && !isFollowRequestSent)
                                                ? followBackButton(state)
                                                : (isUserAFollower && !isUserFollowingThisUser && isFollowRequestSent)
                                                    ? followRequestedInfoButton(state)
                                                    : (!isUserAFollower && !isUserFollowingThisUser && isFollowRequestSent)
                                                        ? followRequestedInfoButton(state)
                                                        : (!isUserAFollower && !isUserFollowingThisUser && !isFollowRequestSent)
                                                            ? followButton(state)
                                                            : Container(),
                            Divider(color: isDarkTheme ? Colors.grey.shade800 : Colors.grey.shade200),
                            Container(
                              height: 100,
                            )
                          ],
                        ),
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
