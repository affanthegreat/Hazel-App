
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hazel_client/bloc/user_profile/user_profile_bloc.dart';
import 'package:hazel_client/constants/colors.dart';
import 'package:hazel_client/main.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:hazel_client/widgets/HazelMetricWidget.dart';

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
    if(searchFieldController.text.isEmpty){
      userProfileBloc.add(UserProfileOnBeginEvent(true));
    } else if(searchFieldController.text.length > 3){
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

  Widget postCreationTextField(){
    return    Container(
      margin: const EdgeInsets.only(top: 0, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
            color: isDarkTheme
                ? Colors.grey.shade900
                : Colors.black,
            width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
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
                    icon:  Icon(
                      Icons.search,
                      color: isDarkTheme? Colors.white: Colors.black,
                      size: 24,
                    ),
                    onPressed: () {
                      if(searchFieldController.text.isNotEmpty){
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
                color: isDarkTheme
                    ? Colors.grey
                    : Colors.grey.shade700,
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {



    return  BlocConsumer<UserProfileBloc, UserProfileState>(
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


              if (state is UserProfileGetFollowersSuccesful && state.listOfUsers.isEmpty){
                return Scaffold(
                  backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                  appBar: AppBar(
                    toolbarHeight: 90,
                    leading: IconButton(icon: const Icon(Icons.arrow_back),padding: EdgeInsets.zero ,onPressed: (){
                      searchFieldController.clear();
                      userProfileBloc.add(UserProfileOnBeginEvent(true));
                    },),
                    title: Text("Your followers",style:GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontWeight: FontWeight.bold,
                      color: isDarkTheme ? Colors.white: Colors.black,
                    ) ,) ,
                    backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                  ),
                  body: Center(
                    child: Text("Looks like you have no followers.",style:GoogleFonts.inter(
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      color: isDarkTheme ? Colors.white: Colors.black,
                    ) ,),
                  ),
                );
              }

              if (state is UserProfileGetFollowersError){
                return Scaffold(
                  backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                  appBar: AppBar(
                    toolbarHeight: 90,
                    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: (){
                      searchFieldController.clear();
                      userProfileBloc.add(UserProfileOnBeginEvent(true));
                    },),
                    title: Text("Your followers",style:GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontWeight: FontWeight.bold,
                      color: isDarkTheme ? Colors.white: Colors.black,
                    ) ,) ,
                    backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                  ),
                  body: Center(
                    child: Text("Error occurred while fetching.",style:GoogleFonts.inter(
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      color: isDarkTheme ? Colors.white: Colors.black,
                    ) ,),
                  ),
                );
              }
              if (state is UserProfileGetFollowingSuccesful && state.listOfUsers.isEmpty){
                return Scaffold(
                  backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                  appBar: AppBar(
                    toolbarHeight: 90,
                    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: (){
                      searchFieldController.clear();
                      userProfileBloc.add(UserProfileOnBeginEvent(true));
                    },),
                    title: Text("Your following",style:GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontWeight: FontWeight.bold,
                      color: isDarkTheme ? Colors.white: Colors.black,
                    ) ,) ,
                    backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                  ),
                  body: Center(
                    child: Text("Looks like you have no one following you.",style:GoogleFonts.inter(
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      color: isDarkTheme ? Colors.white: Colors.black,
                    ) ,),
                  ),
                );
              }

              if (state is UserProfileGetFollowingError){
                return Scaffold(
                  backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                  appBar: AppBar(
                    toolbarHeight: 90,
                    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: (){
                      searchFieldController.clear();
                      userProfileBloc.add(UserProfileOnBeginEvent(true));
                    },),
                    title: Text("Your following",style:GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontWeight: FontWeight.bold,
                      color: isDarkTheme ? Colors.white: Colors.black,
                    ) ,) ,
                    backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                  ),
                  body: Center(
                    child: Text("Error occurred while fetching.",style:GoogleFonts.inter(
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      color: isDarkTheme ? Colors.white: Colors.black,
                    ) ,),
                  ),
                );
              }

              if (state is  UserProfileSearchSuccessful){
                return Scaffold(
                  backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                  appBar: AppBar(
                    toolbarHeight: 90,
                    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: (){
                      searchFieldController.clear();
                      userProfileBloc.add(UserProfileOnBeginEvent(true));
                    },),
                    title: postCreationTextField(),
                    backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                  ),
                  body: state.listOfUsers.isEmpty ? Center(child:Text('No Users found.', style: GoogleFonts.inter(
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      fontWeight: FontWeight.bold,
                      color:isDarkTheme? Colors.white: Colors.black
                  ),) ,):ListView.builder(
                      itemCount: state.listOfUsers.length,
                      itemBuilder: (context,index){
                          if(index == 0){
                            return Container(
                              margin: const EdgeInsets.only(left: 10,right: 10),
                              child: Column(
                                children: [
                                  const Align(
                                      alignment: Alignment.centerLeft,
                                      child: HazelFieldLabel(text: "Found these profiles..")),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                      color: isDarkTheme?Colors.grey.shade900.withOpacity(0.3): Colors.grey.shade100,
                                      border: Border.all(color: isDarkTheme? Colors.grey.shade900:Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          margin: const EdgeInsets.only(top: 10,left: 10),
                                          child: Text("@" + state.listOfUsers[index]!.userName.toString(), style: GoogleFonts.poppins(
                                            textStyle: Theme.of(context).textTheme.bodyLarge,
                                            fontWeight: FontWeight.bold,
                                            color: isDarkTheme
                                                ? Colors.white
                                                : Colors.black,
                                          ),),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Expanded(child: HazelMetricWidget(label: "Followers", value:state.listOfUsers[index]!.userFollowers.toString() , color:CupertinoColors.activeBlue)),
                                              Expanded(child: HazelMetricWidget(label: "Level", value:state.listOfUsers[index]!.userLevel.toString() , color:CupertinoColors.activeBlue)),
                                              Expanded(child: HazelMetricWidget(label: "Exp points", value:state.listOfUsers[index]!.userExperiencePoints.toString() , color:CupertinoColors.activeBlue))

                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                          margin: const EdgeInsets.only(right: 10,bottom: 15,left: 10),
                                          decoration: BoxDecoration(
                                              color: isDarkTheme ? Colors.grey.shade900.withOpacity(0.5) : Colors.grey.shade100,
                                              border: Border.all(color: isDarkTheme? Colors.black: Colors.grey.shade300),
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                          child:InkWell(
                                            onTap: (){
                                              userProfileBloc.add(UserProfileVisitEvent(state.listOfUsers[index]));
                                            },
                                            child: Center(
                                              child:Text("Visit profile", style: GoogleFonts.inter(
                                                  textStyle: Theme.of(context).textTheme.labelLarge,
                                                  fontWeight: FontWeight.bold,
                                                  color: isDarkTheme? Colors.white: Colors.black
                                              ),),
                                            ),
                                          ) ,

                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Container(
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.only(left: 10,right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: isDarkTheme
                                      ? Colors.grey.shade900
                                      : Colors.grey.shade200,
                                  width: 3),
                            ),
                          );
                  })
                );
              }

              if (state is UserProfileSearchFailure){
                return Scaffold(
                  backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                  appBar: AppBar(
                    toolbarHeight: 90,
                    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: (){
                      searchFieldController.clear();
                      userProfileBloc.add(UserProfileOnBeginEvent(true));
                    },),
                    title: postCreationTextField(),
                    backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                  ),
                  body: Center(
                    child: Text("Some error occurred.",style:GoogleFonts.inter(
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      color: isDarkTheme ? Colors.white: Colors.black,
                    ) ,),
                  ),
                );
              }

              if (state is UserProfileLoading) {
                return Scaffold(
                  backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                  appBar: AppBar(
                    toolbarHeight: 90,
                    title: postCreationTextField(),
                    backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                    actions: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: IconButton(onPressed: () {
                        }, icon:const  Icon(Iconsax.safe_home)),
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
                    title: postCreationTextField(),
                    backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                    actions: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: IconButton(onPressed: () {
                        }, icon:const  Icon(Iconsax.safe_home)),
                      ),
                    ],
                  ),
                  body: RefreshIndicator(
                    backgroundColor:
                        isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                    onRefresh: () async {
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
              if(state is UserProfileVisit){
                return Scaffold(
                  backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                  appBar: AppBar(
                    backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: (){
                        searchFieldController.clear();
                        userProfileBloc.add(UserProfileOnBeginEvent(true));
                      },
                    ),
                  ),
                  body: Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    child: RefreshIndicator(
                      backgroundColor:
                      isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                      onRefresh: () async {
                        userProfileBloc.add(UserProfileOnBeginEvent(true));
                      },
                      child: ListView(
                        children: [
                          RichText(
                            text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "@" + state.obj!.userName!,
                                      style: GoogleFonts.poppins(
                                        textStyle: Theme.of(context)
                                            .textTheme.headlineSmall,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkTheme
                                            ? hazelLogoColorLight
                                            : hazelLogoColor,
                                      )),
                                ]),
                          ),
                          Row(
                            children: [
                              HazelMetricWidget(
                                  label: "Total Leaves",
                                  value: (state.obj!.userPublicLeafCount! +
                                      state.obj!.userPrivateLeafCount!)
                                      .toString(),
                                  color: CupertinoColors.activeBlue),
                              Expanded(
                                child: InkWell(
                                  onTap: () {

                                  },
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
                                  child: HazelMetricWidget(
                                      label: "Followers",
                                      value:
                                      (state.obj!.userFollowers).toString(),
                                      color: CupertinoColors.activeBlue),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: HazelMetricWidget(
                                  label: "Experience points",
                                  value: ((state.obj!.userExperiencePoints)!
                                      .toInt())
                                      .toString(),
                                  color: CupertinoColors.systemYellow,
                                ),
                              ),
                              Container(
                                width: 100,
                                child: HazelMetricWidget(
                                    label: "Level",
                                    value: (state.obj!.userLevel!).toString(),
                                  color: isDarkTheme
                                      ? CupertinoColors.systemYellow
                                      : CupertinoColors.systemYellow),
                              ),
                            ],
                          ),
                          (!state.follow_map['follow_request_status'] && !state.follow_map!['following_status']) ? Container(
                            height: 40,
                            margin: const EdgeInsets.only(top: 10,bottom: 10),
                            decoration: BoxDecoration(
                              color: CupertinoColors.activeBlue,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: InkWell(
                              onTap: (){
                                  userProfileBloc.add(UserProfileSendFollowRequestEvent(state.obj, state.follow_map));
                              },
                              child: Center(
                                child: Text("Follow",style: GoogleFonts.inter(
                                  textStyle: Theme.of(context)
                                      .textTheme.bodyMedium,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                )),
                              ),
                            ),
                          ): (state.follow_map!['following_status']) ? Container(
                            height: 40,
                            margin: const EdgeInsets.only(top: 10,bottom: 10),
                            decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Center(
                              child: Text("Already following..",style: GoogleFonts.inter(
                                textStyle: Theme.of(context)
                                    .textTheme.bodyMedium,
                                fontWeight: FontWeight.bold,
                                color: !isDarkTheme
                                    ? hazelLogoColorLight
                                    : hazelLogoColor,
                              )),
                            ),
                          ): (state.follow_map!['follow_request_status']) ?  Container(
                            height: 40,
                            margin: const EdgeInsets.only(top: 10,bottom: 10),
                            decoration: BoxDecoration(
                                color: isDarkTheme? Colors.grey.shade900: Colors.grey.shade100,
                                border: Border.all(color: isDarkTheme? Colors.grey.shade900: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: InkWell(
                              onTap: (){
                                userProfileBloc.add(UserProfileRemoveFollowRequestEvent(state.obj, state.follow_map));
                              },
                              child: Center(
                                child: Text("Follow requested.",style: GoogleFonts.inter(
                                  textStyle: Theme.of(context)
                                      .textTheme.bodyMedium,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkTheme
                                      ? hazelLogoColorLight
                                      : hazelLogoColor,
                                )),
                              ),
                            ),
                          ): Container(),
                          Divider(
                              color: isDarkTheme? Colors.grey.shade800: Colors.grey.shade200
                          ),


                          Container(
                            height: 100,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
              if (state is UserProfileVisitError){
                return Scaffold(
                  backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                  appBar: AppBar(
                    toolbarHeight: 90,
                    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: (){
                      searchFieldController.clear();
                      userProfileBloc.add(UserProfileOnBeginEvent(true));
                    },),
                    title: postCreationTextField(),
                    backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                  ),
                  body: Center(
                    child: Text("Some error occurred.",style:GoogleFonts.inter(
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      color: isDarkTheme ? Colors.white: Colors.black,
                    ) ,),
                  ),
                );
              }
              if (state is UserProfileSuccessfulLoading) {
                return Scaffold(
                  backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                  appBar: AppBar(
                    toolbarHeight: 90,
                    title: postCreationTextField(),
                    backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                    actions:  [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: IconButton(onPressed: () {
                        }, icon:const  Icon(Iconsax.safe_home)),
                      ),
                    ],
                  ),
                  body: Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    child: RefreshIndicator(
                      backgroundColor:
                          isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                      onRefresh: () async {
                        userProfileBloc.add(UserProfileOnBeginEvent(true));
                      },
                      child: ListView(
                        children: [
                          RichText(
                            text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "@" + state.obj!.userName!,
                                      style: GoogleFonts.poppins(
                                        textStyle: Theme.of(context)
                                            .textTheme.headlineSmall,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkTheme
                                            ? hazelLogoColorLight
                                            : hazelLogoColor,
                                      )),
                                ]),
                          ),
                          Container(
                            child: Row(
                              children: [
                                HazelMetricWidget(
                                    label: "Total Leaves",
                                    value: (state.obj!.userPublicLeafCount! +
                                            state.obj!.userPrivateLeafCount!)
                                        .toString(),
                                    color: CupertinoColors.activeBlue),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      userProfileBloc.followingPage = 1;
                                      userProfileBloc.add(UserProfileSeeFollowingEvent());
                                    },
                                    child: HazelMetricWidget(
                                      label: "Following",
                                      value: (state.obj!.userFollowing).toString(),
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
                                    child: HazelMetricWidget(
                                        label: "Followers",
                                        value:
                                            (state.obj!.userFollowers).toString(),
                                        color: CupertinoColors.activeBlue),
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
                                  value: ((state.obj!.userExperiencePoints)!
                                          .toInt())
                                      .toString(),
                                  color: CupertinoColors.systemYellow,
                                ),
                              ),
                              Container(
                                width: 100,
                                child: HazelMetricWidget(
                                    label: "Level",
                                    value: (state.obj!.userLevel!).toString(),
                                  color: CupertinoColors.systemYellow,),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            child: LinearPercentIndicator(
                              lineHeight: 30.0,
                              percent: state.obj!.userExperiencePoints! /
                                  state.obj!.experienceNeededForLevelUp(
                                      state.obj!.userExperiencePoints!),
                              backgroundColor:
                                  Colors.grey.shade900.withOpacity(0.5),
                              animation: true,
                              barRadius: const Radius.circular(10),
                              alignment: MainAxisAlignment.center,
                              center: Text(
                                "${state.obj!.experienceNeededForLevelUp(state.obj!.userExperiencePoints!).toInt() - (state.obj!.userExperiencePoints)!.toInt()} points needed to level up.",
                                style: GoogleFonts.inter(
                                  textStyle:
                                      Theme.of(context).textTheme.labelSmall,
                                  color: Colors.white,
                                ),
                              ),
                              trailing: Text(
                                "${state.obj!.experienceNeededForLevelUp(state.obj!.userExperiencePoints!).toInt()}",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  textStyle:
                                      Theme.of(context).textTheme.bodyMedium,
                                  color: isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              // animateFromLastPercent: true,
                              linearGradient: const LinearGradient(
                                colors: [
                                  CupertinoColors.activeBlue,
                                  CupertinoColors.systemYellow,
                                ],
                              ),

                              // onAnimationEnd: (){print('progress...');},
                              // widgetIndicator: Icon(Icons.arrow_downward_outlined),
                            ),
                          ),
                          Divider(
                            color: isDarkTheme? Colors.grey.shade800: Colors.grey.shade200
                          ),


                          Container(
                            height: 100,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
              return Container();
            });
  }
}
